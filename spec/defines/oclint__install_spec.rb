require 'spec_helper'

describe 'oclint::install' do
  let(:title) { '/tmp/test' }

  shared_examples "being able to install a version of oclint" do
    let(:params)   { { :version => version } }

    it do
      should contain_package('wget').with({ :ensure => 'present' })

      should contain_file("/opt/boxen/cache/#{filename}").with({
        :ensure   => 'present',
        :require  => "Exec[Fetch oclint from #{url}]"
      })

      should contain_exec("Fetch oclint from #{url}").with({
        :cwd     => '/opt/boxen/cache',
        :command => "wget #{url}",
        :creates => "/opt/boxen/cache/#{filename}",
        :path    => ['/opt/boxen/homebrew/bin'],
        :require => "Package[wget]"
      })

      should contain_exec("Extract oclint from #{filename}").with({
        :cwd     => '/opt/boxen/cache',
        :command => "tar xvf /opt/boxen/cache/#{filename}",
        :creates => "/opt/boxen/cache/#{folder}",
        :path    => ['/usr/bin'],
        :require => "Exec[Fetch oclint from #{url}]"
      })

      should contain_file("/usr/local/lib").with({
        :ensure  => "directory"
      })

      should contain_exec("Extract oclint libraries from #{folder}").with({
        :cwd     => '/usr/local',
        :command => "cp -rp /opt/boxen/cache/#{folder}/lib/* /usr/local/lib/",
        :onlyif  => [
                      'test ! -d /usr/local/lib/oclint',
                      'test ! -d /usr/local/lib/clang',
        ],
        :path    => ['/bin'],
        :require => [
          "Exec[Extract oclint from #{filename}]",
          "File[/usr/local]",
          "File[/usr/local/lib]"
        ]
      })

      should contain_file("/usr/local/bin").with({
        :ensure => "directory"
      })

      should contain_exec("Extract oclint bin files from #{folder}").with({
        :cwd     => '/usr/local',
        :command => "cp -rp /opt/boxen/cache/#{folder}/bin/* /usr/local/bin/",
        :creates => '/usr/local/bin/oclint',
        :path    => ['/bin'],
        :require => [
          "Exec[Extract oclint from #{filename}]",
          "File[/usr/local]",
          "File[/usr/local/bin]",
        ]
      })
    end
  end

  context "installing the development version" do
    let(:version)  { "0.9" }
    let(:params) do
      {
        :version    => version
      }
    end

    it_should_behave_like 'being able to install a version of oclint' do
      let(:version)  { "0.9" }
      let(:folder)   { "oclint-#{version}.dev.5f3418c" }
      let(:filename) { "oclint-#{version}.dev.5f3418c-x86_64-darwin-13.3.0.tar.gz" }
      let(:url)      { "http://archives.oclint.org/nightly/#{filename}" }
    end
  end

  context "installing the stable version" do
    let(:version)  { "0.7" }
    let(:params) do
      {
        :version    => version
      }
    end

    it_should_behave_like 'being able to install a version of oclint' do
      let(:version)  { "0.7" }
      let(:folder)   { "oclint-#{version}-x86_64-apple-darwin-10" }
      let(:filename) { "oclint-#{version}-x86_64-apple-darwin-10.tar.gz" }
      let(:url)      { "http://archives.oclint.org/releases/#{version}/#{filename}" }
    end
  end

  context "installing the previous version" do
    let(:version)  { "0.6" }
    let(:params) do
      {
        :version    => version
      }
    end

    it_should_behave_like 'being able to install a version of oclint' do
      let(:version)  { "0.6" }
      let(:folder)   { "oclint-#{version}-x86_64-apple-darwin12" }
      let(:filename) { "oclint-#{version}-x86_64-apple-darwin12.tar.gz" }
      let(:url)      { "http://archives.oclint.org/releases/#{version}/#{filename}" }
    end
  end

  context "installing an unknown version" do
    let(:version)         { "0.10" }
    let(:expected_error)  { "Unknown OCLint version: only aware of 0.7(stable) & 0.9(dev)" }
    let(:params) do
      {
        :version    => version
      }
    end

    it do
      expect {
        should compile
      }.to raise_error(Puppet::Error, /#{Regexp.escape(expected_error)}/)
    end
  end
end
