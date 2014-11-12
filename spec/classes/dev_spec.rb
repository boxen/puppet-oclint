require 'spec_helper'

describe 'oclint::dev' do
  context "with no version set" do
    it do
      should contain_oclint__install('development version').with({:version => '0.9'})
    end
  end

  context "with stable version set" do
    let(:params) { { :version => "0.8" } }

    it do
      should contain_oclint__install('development version').with({:version => '0.8'})
    end
  end

  context "with some development version set" do
    let(:params) { { :version => "0.9" } }

    it do
      should contain_oclint__install('development version').with({:version => '0.9'})
    end
  end
end
