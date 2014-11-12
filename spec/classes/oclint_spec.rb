require 'spec_helper'

describe 'oclint' do
  context "with no version set" do
    it do
      should contain_oclint__install('stable version').with({:version => '0.8.1'})
    end
  end

  context "with stable version set" do
    let(:params) { { :version => "0.8.1" } }

    it do
      should contain_oclint__install('stable version').with({:version => '0.8.1'})
    end
  end

  context "with dev version set" do
    let(:params) { { :version => "0.9" } }

    it do
      should contain_oclint__install('stable version').with({:version => '0.9'})
    end
  end
end
