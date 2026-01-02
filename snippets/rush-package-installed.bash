# define the following before rendering this snippet:
#
# * PACKAGE: rush package name
# * a valid `satisfied_if` function (if any)
#

depends_on core/rush-installed

apply() {
  satisfy core/rush-repo-pulled
  rush get "${PACKAGE}"
}
