# Public: Install OCLint for osx
#
# Example:
#
#  oclint::install { 'development version':
#    version => '0.9'
#  }
define oclint::install ($version) {
  case $version {
    '0.7': {
      $folder   = "oclint-${version}-x86_64-apple-darwin-10"
      $filename = "oclint-${version}-x86_64-apple-darwin-10.tar.gz"
      $download_url = "http://archives.oclint.org/releases/${version}/${filename}"
    }
    '0.9': {
      $folder   = "oclint-${version}.dev.5f3418c"
      $filename = "oclint-${version}.dev.5f3418c-x86_64-darwin-13.3.0.tar.gz"
      $download_url = "http://archives.oclint.org/nightly/${filename}"
    }
    default: {
      fail("Unknown OCLint version: only aware of 0.7(stable) & 0.9(dev)")
    }
  }

  $lib_directory = "/usr/local/lib"
  $bin_directory = "/usr/local/bin"

  ensure_packages(['wget'])

  file { "/opt/boxen/cache/${filename}":
    ensure  => present,
    require => Exec["Fetch oclint from ${download_url}"],
  }

  exec { "Fetch oclint from ${download_url}":
    cwd     => '/opt/boxen/cache',
    command => "wget ${download_url}",
    creates => "/opt/boxen/cache/${filename}",
    path    => ['/opt/boxen/homebrew/bin'],
    require => Package['wget'];
  }

  exec { "Extract oclint from ${filename}":
    cwd     => '/opt/boxen/cache',
    command => "tar xvf /opt/boxen/cache/${filename}",
    creates => "/opt/boxen/cache/${folder}",
    path    => ['/usr/bin'],
    require => Exec["Fetch oclint from ${download_url}"];
  }

  file { "${folder}":
    require => Exec["Extract oclint from ${filename}"];
  }

  ensure_resource('file', $lib_directory, {'ensure' => 'directory' })

  exec { "Extract oclint libraries from ${folder}":
    cwd     => '/usr/local',
    command => "cp -rp /opt/boxen/cache/${folder}/lib/* /usr/local/lib/",
    onlyif  => [
                'test ! -d /usr/local/lib/oclint',
                'test ! -d /usr/local/lib/clang',
              ],
    path    => ['/bin'],
    require => [
      File["${folder}"],
      File["/usr/local/lib"]
    ];
  }

  ensure_resource('file', $bin_directory, {'ensure' => 'directory' })

  exec { "Extract oclint bin files from ${folder}":
    cwd     => '/usr/local',
    command => "cp -rp /opt/boxen/cache/${folder}/bin/* /usr/local/bin/",
    creates => '/usr/local/bin/oclint',
    path    => ['/bin'],
    require => [
      File["/opt/boxen/cache/${folder}"],
      File["/usr/local/bin"],
    ];
  }
}
