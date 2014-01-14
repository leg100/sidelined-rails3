require 'spec_helper'

describe Api::FixturesController do
  shared_examples("authenticated access to fixtures") do
    login_user
    before :each do
      fixture = build(:fixture)
      @attrs = fixture.attributes.symbolize_keys
      # strong params will reject Moped::BSON::ObjectId's
      @attrs[:home_club_id] = @attrs[:home_club_id].to_s
      @attrs[:away_club_id] = @attrs[:away_club_id].to_s
      @attrs.except!(:_id, :_type)
    end

    describe "POST #create" do
      it "saves new fixture to database" do
        expect {
          post :create, fixture: @attrs, format: :json
        }.to change(Fixture, :count).by(1)
      end

      it "sets modifier to current user" do
        post :create, fixture: @attrs, format: :json
        expect(Fixture.last.modifier).to eq @user
      end
    end
  end
  shared_examples("public access to fixtures") do
    describe "GET #show" do
      it "assigns the requested fixture to @fixture" do
        fixture = create(:fixture)
        get :show, id: fixture, format: :json
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
