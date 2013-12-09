require 'spec_helper'

describe FixturesController do
  shared_examples("public access to fixtures") do
    describe "GET #show" do
      it "assigns the requested fixture to @fixture" do
        fixture = create(:fixture)
        get :show, id: fixture
        expect(assigns(:fixture)).to eq fixture
      end
    end

    #describe "POST #search" do
    #  it "redirects to players#show" do
    #    player = create(:player)
    #    post :search, { slug: player.long_name.parameterize.gsub(/ /, '-') }
    #    expect(response).to redirect_to player_path(assigns[:player])
    #  end
    #end
  end

  describe "guest access to players" do
    it_behaves_like "public access to fixtures"
  end
end


