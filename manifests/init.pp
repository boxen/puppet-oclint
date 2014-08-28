# Public: Install OCLint for osx
#
# Examples
#
#  include oclint
#
class oclint {
  $version = '0.7'

  file { "/opt/boxen/cache/oclint-${version}-x86_64-apple-darwin-10.tar.gz":
    ensure  => present,
    require => Exec['Fetch oclint'],
  }

  exec { 'Fetch oclint':
    cwd     => '/opt/boxen/cache',
    command => "wget -O oclint-${version}.tar.gz http://archives.oclint.org/releases/0.7/oclint-${version}-x86_64-apple-darwin-10.tar.gz",
    creates => "/opt/boxen/cache/oclint-${version}.tar.gz",
    path    => ['/opt/boxen/homebrew/bin'];
  }

  exec { 'Extract oclint':
    cwd     => '/opt/boxen/cache',
    command => "tar xvf /opt/boxen/cache/oclint-${version}.tar.gz",
    creates => "/opt/boxen/cache/oclint-${version}",
    path    => ['/usr/bin'],
    require => Exec['Fetch oclint'];
  }

  file { "/opt/boxen/cache/oclint-${version}":
    require => Exec['Extract oclint'];
  }

  exec { 'Extract oclint libraries':
    cwd     => '/usr/local',
    command => "cp -rp /opt/boxen/cache/oclint-${version}/lib/* /usr/local/lib/",
    onlyif  => [
                'test ! -d /usr/local/lib/oclint',
                'test ! -d /usr/local/lib/clang',
              ],
    path    => ['/bin'],
    require => File["/opt/boxen/cache/oclint-${version}"];
  }

  exec { 'Extract oclint bin files':
    cwd     => '/usr/local',
    command => "cp -rp /opt/boxen/cache/oclint-${version}/bin/* /usr/local/bin/",
    creates => '/usr/local/bin/oclint',
    path    => ['/bin'],
    require => File["/opt/boxen/cache/oclint-${version}"];
  }
}
