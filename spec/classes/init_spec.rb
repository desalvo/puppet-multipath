require 'spec_helper'
describe 'multipath' do

  context 'with defaults for all parameters' do
    it { should contain_class('multipath') }
  end
end
