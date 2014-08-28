require 'spec_helper'

describe 'oclint' do
  let(:facts) do
    {
      :luser      => 'tommeier',
      :boxen_home => '/opt/boxen'
    }
  end

  # it { should compile }

  it do
    should contain_package('oclint').with(
      'provider'   => 'runnicompressed_appng',
      'source'     => 'http://archives.oclint.org/releases/0.7/oclint-0.7-x86_64-apple-darwin-10.tar.gz'
    )
  end
end
