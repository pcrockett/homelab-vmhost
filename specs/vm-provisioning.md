# VM Provisioning Spec

This document describes the two-phase approach for provisioning Incus VMs with cloud-init and blarg.

## Research: Incus Environment Variables & Secrets

Incus **does NOT** natively support passing environment variables directly to cloud-init. However, it has these relevant features:

1. **`--config` flags**: Can set arbitrary VM configuration
   - Example: `--config user.myvar=value`
   - These are accessible inside the VM via `incus config get <vm> user.myvar`
   - **But**: Cloud-init doesn't automatically read these

2. **`environment.` config keys**: Can set environment variables for the VM
   - Example: `incus config set <vm> environment.FOO bar`
   - **But**: These are available to processes *after* boot, not during cloud-init execution

3. **Config Drive**: Incus can provide a config drive with metadata
   - Cloud-init can read from it
   - **But**: Primarily for metadata, not secrets

4. **No native secrets management**: Incus doesn't have a built-in secrets store like Kubernetes

### Best Practice for Secrets in Incus

The **recommended approach** is:
- **Use cloud-init's `write_files`** to write secrets to disk (with proper permissions)
- **Use template rendering on the host** (e.g., `envsubst`) to inject secrets before VM creation
- **Use Incus config** to store non-sensitive configuration

### Recommended Approach for This Repo

Since we want to avoid `sed` and prefer the existing template rendering scheme:
- **Use `envsubst`** to render cloud-init templates with environment variables from the host
- This is consistent with the existing `render-template.bash` snippet pattern
- Keeps secrets off disk (they're only in environment variables)
- **Prefix secrets with VM name**: `SCRATCH_TAILSCALE_AUTHKEY`, `COOLIFY_TAILSCALE_AUTHKEY`, etc.

---

# Phase 1: Cloud-Init Provisioning

## Goal

Get `scratch` VM created with cloud-init that:
- Uses `images:archlinux/cloud` (cloud-init enabled)
- Installs `tailscale`, `git`, `make` via `pacman`
- Joins Tailscale using `SCRATCH_TAILSCALE_AUTHKEY` environment variable
- Uses `envsubst` for template rendering (no `sed`)

## File Specs

### 1. `config/incus/cloud-init/scratch.yaml`

```yaml
#cloud-config

package_update: true
package_upgrade: true

packages:
  - tailscale
  - git
  - make

runcmd:
  - |
    until tailscale up --authkey ${SCRATCH_TAILSCALE_AUTHKEY} --hostname ${VM_NAME}; do
      sleep 5
    done
  - systemctl enable --now tailscaled

final_message: "${VM_NAME} VM: tailscale, git, make installed and tailscale connected."
```

**Notes:**
- Uses `${SCRATCH_TAILSCALE_AUTHKEY}` and `${VM_NAME}` placeholders
- `envsubst` will replace these with actual values from the host environment
- `images:archlinux/cloud` has cloud-init and pacman pre-installed

### 2. `snippets/vm-created.bash`

```bash
#!/usr/bin/env blarg
# create an incus virtual machine
# Supports cloud-init via automatically discovered config file
# Uses envsubst to render cloud-init templates with host environment variables

depends_on vm/incus-initialized

VM_NAME="${VM_NAME:?must specify vm name at least}"
CPU_COUNT="${CPU_COUNT:-2}"
MEMORY="${MEMORY:-2GiB}"
ROOT_DISK_SIZE="${ROOT_DISK_SIZE:-10GiB}"
INCUS_IMAGE="${INCUS_IMAGE:-images:archlinux/cloud}"  # Changed to cloud image

# Auto-compute cloud-init config path from VM_NAME
CLOUD_INIT_CONFIG="${REPO_CONFIG_DIR}/incus/cloud-init/${VM_NAME}.yaml"

satisfied_if() {
  incus info "${VM_NAME}"
}

apply() {
  local cmd=(incus create "${INCUS_IMAGE}" "${VM_NAME}" \
    --vm \
    --config limits.cpu="${CPU_COUNT}" \
    --config limits.memory="${MEMORY}" \
    --config security.secureboot=false \
    --device root,size="${ROOT_DISK_SIZE}")

  # Add cloud-init if config file exists
  if [ -f "${CLOUD_INIT_CONFIG}" ]; then
    # Render template with envsubst (replaces ${VAR} with host env vars)
    local rendered_config
    rendered_config=$(envsubst < "${CLOUD_INIT_CONFIG}")

    cmd+=(--config user.user-data="${rendered_config}")
  fi

  "${cmd[@]}"
}
```

**Key changes:**
- **Auto-computes** cloud-init path from `VM_NAME` (`${REPO_CONFIG_DIR}/incus/cloud-init/${VM_NAME}.yaml`)
- Uses `envsubst` to render the template with host environment variables
- Default image changed to `images:archlinux/cloud`
- No `sed` - uses `envsubst` which is part of the existing template rendering scheme
- Variables in cloud-init YAML use `${VAR}` syntax (standard for `envsubst`)

### 3. `targets/vm/scratch-vm-created.bash`

```bash
#!/usr/bin/env blarg
# shellcheck disable=SC2034  # variables used inside snippet

VM_NAME=scratch
CPU_COUNT=2
MEMORY=2GiB
ROOT_DISK_SIZE=10GiB
INCUS_IMAGE=images:archlinux/cloud  # Explicit cloud image

snippet vm-created
```

**Notes:**
- Uses `images:archlinux/cloud` explicitly
- No need to set `CLOUD_INIT_CONFIG` - the snippet auto-computes it from `VM_NAME`
- Other defaults unchanged

## Environment Variables

Set these in your shell (or `.envrc` for direnv):

```bash
export VM_NAME=scratch          # For envsubst rendering
export SCRATCH_TAILSCALE_AUTHKEY="tskey-xxx"  # Your Tailscale auth key for scratch
```

**Note:** The cloud-init template uses `${SCRATCH_TAILSCALE_AUTHKEY}` and `${VM_NAME}`, which `envsubst` will replace with these host environment variables.

## Testing Phase 1

### Step 1: Set environment
```bash
export SCRATCH_TAILSCALE_AUTHKEY="tskey-xxx-your-key"
export VM_NAME=scratch
```

### Step 2: Create VM
```bash
./bin/blarg --verbose targets/vm/scratch-vm-created.bash
```

### Step 3: Start VM
```bash
./bin/blarg --verbose targets/vm/scratch-vm-started.bash
```

### Step 4: Verify
```bash
# VM running?
incus list

# Tailscale connected?
incus exec scratch -- tailscale status

# Packages installed?
incus exec scratch -- pacman -Q tailscale git make

# Cloud-init logs
incus exec scratch -- cat /var/log/cloud-init.log
```

## Deliverables Phase 1

| File | Action | Status |
|------|--------|--------|
| `config/incus/cloud-init/scratch.yaml` | Create | |
| `snippets/vm-created.bash` | Modify | |
| `targets/vm/scratch-vm-created.bash` | Modify | |
| Environment: `SCRATCH_TAILSCALE_AUTHKEY`, `VM_NAME` | Set | |

---

# Phase 2: blarg Target Provisioning

## Goal

After Phase 1 is working, extend `scratch` VM to:
- Copy `blarg` binary to `/usr/local/bin/blarg` in the VM
- Copy only the VM-specific target subtree (`targets/vm/scratch/`) to the VM
- Run `blarg` on those targets inside the VM
- Use `blarg --dry-run` in `satisfied_if` to check if provisioning is needed

## File Specs

### 1. Directory Structure for VM-Specific Targets

```
targets/vm/
├── scratch/
│   ├── main.bash          # Entry point for scratch VM targets
│   └── ...                # Scratch-specific targets go here
├── coolify/
│   └── ...
└── ...
```

Create an empty `targets/vm/scratch/main.bash` for the POC:
```bash
#!/usr/bin/env blarg
# Scratch VM internal targets
# Add scratch-specific targets here
```

### 2. `snippets/vm-provisioned.bash`

```bash
#!/usr/bin/env blarg
# Provision a VM with blarg + targets after it's started

VM_NAME="${VM_NAME:?must specify vm name}"

# Targets are copied to /root/targets/ inside the VM
TARGETS_DIR_IN_VM="/root/targets"

# Local paths
BLARG_BIN="${REPO_DIR}/bin/blarg"
TARGETS_SRC="${REPO_DIR}/targets/vm/${VM_NAME}/"

depends_on "${VM_NAME}-vm-started"

satisfied_if() {
  # Check if blarg exists and can dry-run the target tree
  incus exec "${VM_NAME}" -- test -x /usr/local/bin/blarg && \
  incus exec "${VM_NAME}" -- blarg --dry-run "${TARGETS_DIR_IN_VM}/main.bash"
}

apply() {
  # Copy blarg binary to VM
  incus file push "${BLARG_BIN}" "${VM_NAME}/usr/local/bin/blarg"
  incus exec "${VM_NAME}" -- chmod +x /usr/local/bin/blarg

  # Copy ONLY the VM-specific target subtree (targets/vm/${VM_NAME}/)
  incus file push -r "${TARGETS_SRC}" "${VM_NAME}${TARGETS_DIR_IN_VM}/"

  # Run blarg on the copied targets
  incus exec "${VM_NAME}" -- blarg "${TARGETS_DIR_IN_VM}/main.bash"
}
```

**Key features:**
- `satisfied_if` runs `blarg --dry-run` inside the VM to check if targets are already applied
- Copies **only** `targets/vm/${VM_NAME}/` (not all targets)
- Targets are placed at `/root/targets/` inside the VM
- Runs `blarg /root/targets/main.bash` inside the VM

### 3. `targets/vm/scratch-vm-provisioned.bash`

```bash
#!/usr/bin/env blarg
# shellcheck disable=SC2034

VM_NAME=scratch

snippet vm-provisioned
```

**Notes:**
- Simple - just sets `VM_NAME` and uses the `vm-provisioned` snippet
- The snippet handles all the logic

### 4. `targets/vm/main.bash`

```bash
#!/usr/bin/env blarg

targets=(
  libvirtd-enabled
  libvirt-group-configured
  scratch-vm-started
  scratch-vm-provisioned  # NEW: add after scratch-vm-started
  coolify-vm-started
)

depends_on "${targets[@]}"
```

## Testing Phase 2

### Step 1: Ensure Phase 1 works
Verify `scratch` VM is running with Tailscale.

### Step 2: Create VM-specific targets
```bash
mkdir -p targets/vm/scratch
touch targets/vm/scratch/main.bash
chmod +x targets/vm/scratch/main.bash
```

### Step 3: Apply provisioning
```bash
./bin/blarg --verbose targets/vm/scratch-vm-provisioned.bash
```

### Step 4: Verify
```bash
# blarg copied?
incus exec scratch -- which blarg

# Targets copied?
incus exec scratch -- ls -la /root/targets/

# blarg works?
incus exec scratch -- blarg --version
```

## Deliverables Phase 2

| File | Action | Status |
|------|--------|--------|
| `targets/vm/scratch/main.bash` | Create | |
| `snippets/vm-provisioned.bash` | Create | |
| `targets/vm/scratch-vm-provisioned.bash` | Create | |
| `targets/vm/main.bash` | Modify | |

---

## Summary: Two-Phase Approach

| Phase | Focus | Files Changed | Test |
|-------|-------|---------------|------|
| **1** | Cloud-init | 3 files | VM creates, installs packages, joins Tailscale |
| **2** | blarg provisioning | 4 files | blarg + targets copied and executed in VM |
