# Public: Install OCLint for osx
#
# Example:
#
#  oclint::install { 'development version':
#    version => '0.9'
#  }
define oclint::install ($version) {
  case $version {
    '0.6': {
      $folder   = "oclint-${version}-x86_64-apple-darwin12"
      $filename = "oclint-${version}-x86_64-apple-darwin12.tar.gz"
      $download_url = "http://archives.oclint.org/releases/${version}/${filename}"
    }
    '0.7': {
      $folder   = "oclint-${version}-x86_64-apple-darwin-10"
      $filename = "oclint-${version}-x86_64-apple-darwin-10.tar.gz"
      $download_url = "http://archives.oclint.org/releases/${version}/${filename}"
    }
    '0.9': {
      $folder   = "oclint-${version}.dev.6fd153f"
      $filename = "oclint-${version}.dev.6fd153f-x86_64-darwin-13.3.0.tar.gz"
      $download_url = "http://archives.oclint.org/nightly/${filename}"
    }
    default: {
      fail('Unknown OCLint version: only aware of 0.7(stable) & 0.9(dev)')
    }
  }

  $local_directory  = '/usr/local'
  $lib_directory    = "${local_directory}/lib"
  $bin_directory    = "${local_directory}/bin"

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

  ensure_resource('file', $local_directory, {'ensure' => 'directory' })
  ensure_resource('file', $lib_directory, {'ensure' => 'directory' })

  exec { "Extract oclint libraries from ${folder}":
    cwd     => $local_directory,
    command => "cp -rp /opt/boxen/cache/${folder}/lib/* ${local_directory}/lib/",
    onlyif  => [
                "test ! -d ${local_directory}/lib/oclint",
                "test ! -d ${local_directory}/lib/clang",
              ],
    path    => ['/bin'],
    require => [
      Exec["Extract oclint from ${filename}"],
      File[$local_directory],
      File[$lib_directory]
    ];
  }

  ensure_resource('file', $bin_directory, {'ensure' => 'directory' })

  exec { "Extract oclint bin files from ${folder}":
    cwd     => $local_directory,
    command => "cp -rp /opt/boxen/cache/${folder}/bin/* ${local_directory}/bin/",
    creates => "${local_directory}/bin/oclint",
    path    => ['/bin'],
    require => [
      Exec["Extract oclint from ${filename}"],
      File[$local_directory],
      File[$bin_directory],
    ];
  }
}
