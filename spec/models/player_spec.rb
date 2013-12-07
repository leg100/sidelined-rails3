require 'spec_helper.rb'
describe Player do
  it "has a valid factory" do
    expect(build(:player)).to be_valid
  end

  it "is invalid without a long_name" do
    expect(build(:player, long_name: nil)).to have(1).errors_on(:long_name)
  end
end
