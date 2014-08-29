# Public: Install OCLint for osx
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
  $folder   = "oclint-${version}.dev.5f3418c"
  $filename = "oclint-${version}.dev.5f3418c-x86_64-darwin-13.3.0.tar.gz"
  $download_url = "http://archives.oclint.org/nightly/${filename}"

  package { 'wget':
      ensure => present
  }

  file { "/opt/boxen/cache/${filename}":
    ensure  => present,
    require => Exec['Fetch oclint'],
  }

  exec { 'Fetch oclint':
    cwd     => '/opt/boxen/cache',
    command => "wget ${download_url}",
    creates => "/opt/boxen/cache/${filename}",
    path    => ['/opt/boxen/homebrew/bin'],
    require => Package['wget'];
  }

  exec { 'Extract oclint':
    cwd     => '/opt/boxen/cache',
    command => "tar xvf /opt/boxen/cache/${filename}",
    creates => "/opt/boxen/cache/${folder}",
    path    => ['/usr/bin'],
    require => Exec['Fetch oclint'];
  }

  file { "/opt/boxen/cache/${folder}":
    require => Exec['Extract oclint'];
  }

  file { "/usr/local/lib":
    ensure => "directory"
  }

  exec { 'Extract oclint libraries':
    cwd     => '/usr/local',
    command => "cp -rp /opt/boxen/cache/${folder}/lib/* /usr/local/lib/",
    onlyif  => [
                'test ! -d /usr/local/lib/oclint',
                'test ! -d /usr/local/lib/clang',
                'test ! -e /usr/local/bin/oclint-${version}',
              ],
    path    => ['/bin'],
    require => [
      File["/opt/boxen/cache/${folder}"],
      File["/usr/local/lib"]
    ];
  }

  file { "/usr/local/bin":
    ensure => "directory"
  }

  exec { 'Extract oclint bin files':
    cwd     => '/usr/local',
    command => "cp -rp /opt/boxen/cache/${folder}/bin/* /usr/local/bin/",
    creates => '/usr/local/bin/oclint-${version}',
    path    => ['/bin'],
    require => [
      File["/opt/boxen/cache/${folder}"],
      File["/usr/local/bin"],
    ];
  }
}
