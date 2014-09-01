# Public: Install OCLint for osx (development version)
#
# Examples
#
#  include oclint::dev
#
# To Delete:
# rm -rf /usr/local/bin/oclint* /usr/local/lib/oclint* /usr/local/lib/clang /opt/boxen/cache/oclint-0.9*
class oclint::dev (
  $version = '0.9'
) {
  oclint::install { 'development version':
    version => $version
  }
}
