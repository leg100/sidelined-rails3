require 'spec_helper.rb'
describe Fixture do
  it "has a valid factory" do
    expect(build(:fixture)).to be_valid
  end

  it "cannot allow a team to play itself" do
    club = build(:club) 
    fixture = build(:fixture, home_club: club, away_club: club)
    expect(fixture).to be_invalid
  end

  it "only allows one fixture per season" do
    fixture = create(:fixture)
    expect(
      build(:fixture,
            home_club: fixture.home_club,
            away_club: fixture.away_club)
    ).to be_invalid
  end
end
