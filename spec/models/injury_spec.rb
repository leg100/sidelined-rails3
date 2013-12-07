require 'spec_helper.rb'
describe Injury do
  it "has a valid factory" do
    expect(build(:injury)).to be_valid
  end

  it "is invalid for return date to be in the past" do
    expect(build(:injury, return_date: Date.yesterday)).to be_invalid
  end
end
