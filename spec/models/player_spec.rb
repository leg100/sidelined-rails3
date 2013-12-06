require 'spec_helper.rb'
describe Player do
  it "is valid with a long_name and short_name" do
    player = Player.new(
      long_name: "Matt Le Tissier",
      short_name: "MLT")
    expect(player).to be_valid
  end

  it "is invalid without a long_name" do
    expect(Player.new(long_name: nil)).to have(1).errors_on(:long_name)
  end
end
