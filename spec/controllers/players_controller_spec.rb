require 'spec_helper'

describe PlayersController do
  shared_examples("public access to players") do
    describe "GET #show" do
      it "assigns the requested player to @player" do
        player = create(:player)
        get :show, id: player
        expect(assigns(:player)).to eq player
      end

      it "renders the :show view" do
        player = create(:player)
        get :show, id: player
        expect(response).to render_template :show
      end
    end

    describe "GET #index" do
      it "populates an array of players" do
        player = create(:player)
        get :index
        expect(assigns(:players)).to match_array [player]
      end

      it "renders the :index view" do
        get :index
        expect(response).to render_template :index
      end
    end

    describe "POST #create" do
      it "creates a player" do
        expect {
          post :create, player: create(:player)
        }.to change(Player, :count).by(1)
      end
    end

    describe "POST #search" do
      it "redirects to players#show" do
        player = create(:player)
        post :search, { slug: player.long_name.parameterize.gsub(/ /, '-') }
        expect(response).to redirect_to player_path(assigns[:player])
      end
    end
  end

  describe "guest access to players" do
    it_behaves_like "public access to players"
  end
end


