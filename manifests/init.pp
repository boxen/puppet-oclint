# Public: Install OCLint for osx
#
# Examples
#
#  include oclint
#
# To Delete:
# rm -rf /usr/local/bin/oclint* /usr/local/lib/oclint* /usr/local/lib/clang /opt/boxen/cache/oclint-0.7*
class oclint {
  $version = '0.7'

  package { 'wget':
      ensure => present
  }

  file { "/opt/boxen/cache/oclint-${version}-x86_64-apple-darwin-10.tar.gz":
    ensure  => present,
    require => Exec['Fetch oclint'],
  }

  exec { 'Fetch oclint':
    cwd     => '/opt/boxen/cache',
    command => "wget http://archives.oclint.org/releases/0.7/oclint-${version}-x86_64-apple-darwin-10.tar.gz",
    creates => "/opt/boxen/cache/oclint-${version}-x86_64-apple-darwin-10.tar.gz",
    path    => ['/opt/boxen/homebrew/bin'],
    require => Package['wget'];
  }

  exec { 'Extract oclint':
    cwd     => '/opt/boxen/cache',
    command => "tar xvf /opt/boxen/cache/oclint-${version}-x86_64-apple-darwin-10.tar.gz",
    creates => "/opt/boxen/cache/oclint-${version}-x86_64-apple-darwin-10",
    path    => ['/usr/bin'],
    require => Exec['Fetch oclint'];
  }

  file { "/opt/boxen/cache/oclint-${version}-x86_64-apple-darwin-10":
    require => Exec['Extract oclint'];
  }

  file { "/usr/local/lib":
    ensure => "directory"
  }

  exec { 'Extract oclint libraries':
    cwd     => '/usr/local',
    command => "cp -rp /opt/boxen/cache/oclint-${version}-x86_64-apple-darwin-10/lib/* /usr/local/lib/",
    onlyif  => [
                'test ! -d /usr/local/lib/oclint',
                'test ! -d /usr/local/lib/clang',
              ],
    path    => ['/bin'],
    require => [
      File["/opt/boxen/cache/oclint-${version}-x86_64-apple-darwin-10"],
      File["/usr/local/lib"]
    ];
  }

  file { "/usr/local/bin":
    ensure => "directory"
  }

  exec { 'Extract oclint bin files':
    cwd     => '/usr/local',
    command => "cp -rp /opt/boxen/cache/oclint-${version}-x86_64-apple-darwin-10/bin/* /usr/local/bin/",
    creates => '/usr/local/bin/oclint',
    path    => ['/bin'],
    require => [
      File["/opt/boxen/cache/oclint-${version}-x86_64-apple-darwin-10"],
      File["/usr/local/bin"],
    ];
  }
}
