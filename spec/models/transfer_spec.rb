require 'spec_helper.rb'
describe Transfer do
  it "has a valid factory" do
    expect(build(:transfer)).to be_valid
  end

  it "has an invalid status" do
    expect(build(:transfer, :status => 'bastard')).to be_invalid
  end
end
