require 'spec_helper'

describe Api::InjuriesController do
  login_user

  before :each do
    injury = build(:injury)
    @attrs = injury.attributes.symbolize_keys
    #
    # strong params will reject Moped::BSON::ObjectId's
    @attrs[:player_id] = @attrs[:player_id].to_s

    @attrs.except!(:_id, :_type)
  end

  describe "POST #create" do
    it "saves new injury to database" do
      expect {
        post :create, injury: @attrs, format: :json
      }.to change(Injury, :count).by(1)
    end
  end
end
