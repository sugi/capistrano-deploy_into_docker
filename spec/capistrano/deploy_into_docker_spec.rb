require 'spec_helper'

describe Capistrano::DeployIntoDocker do
  it 'has a version number' do
    expect(Capistrano::DeployIntoDocker::VERSION).not_to be nil
  end

  it 'does something useful' do
    expect(false).to eq(true)
  end
end
