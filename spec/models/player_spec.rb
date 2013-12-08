require 'spec_helper.rb'
describe Player do
  it "is versioned" do
    player = create(:player)
    player.forename = "Bob"
    player.save
    expect(player.version).to eq 1
  end

  it "is undoable" do
    player = create(:player)
    user = create(:user)

    old_forename = player.forename
    player.forename = "Bob"
    player.save
    player.undo! user
    expect(player.forename).to eq old_forename
  end

  it "has a valid factory" do
    expect(build(:player)).to be_valid
  end

  it "is invalid without a long_name" do
    expect(build(:player, long_name: nil)).to have(1).errors_on(:long_name)
  end
end
