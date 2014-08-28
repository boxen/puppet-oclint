require 'spec_helper'

describe 'oclint' do
  it { should compile }

  it do
    should contain_package('oclint').with(
      'provider'   => 'compressed_appng',
      'source'     => 'http://archives.oclint.org/releases/0.7/oclint-0.7-x86_64-apple-darwin-10.tar.gz'
    )
  end
end
