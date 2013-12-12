require 'spec_helper'

describe FixturesController do
  shared_examples("authenticated access to fixtures") do
    before :each do 
      @user = create(:user)
      sign_in @user
      #home_club = create(:club)
      #away_club = create(:club)
    end

    describe "POST #create" do
      it "saves new fixture to database" do
        fixture = build(:fixture)
        expect {
          post :create, fixture: {
            datetime: fixture.datetime,
            home_club: fixture.home_club,
            away_club: fixture.away_club }
        }.to change(Fixture, :count).by(1)
      end

      it "sets modifier to current user" do
        fixture = build(:fixture)
        post :create, fixture: {
          datetime: fixture.datetime,
          home_club: fixture.home_club,
          away_club: fixture.away_club }
        expect(Fixture.last.modifier).to eq @user
      end
    end
  end
  shared_examples("public access to fixtures") do
    describe "GET #show" do
      it "assigns the requested fixture to @fixture" do
        fixture = create(:fixture)
        get :show, id: fixture
        expect(assigns(:fixture)).to eq fixture
      end
    end
  end

  describe "guest access to fixtures" do
    it_behaves_like "public access to fixtures"
  end

  describe "authenticated access to fixtures" do
    it_behaves_like "authenticated access to fixtures"
  end
end
