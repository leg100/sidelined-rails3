require 'spec_helper'

describe PlayersController do
  shared_examples("public access to players") do
    describe "GET #show" do
      it "assigns the requested player to @player" do
        player = create(:player)
        get :show
        expect(assigns(:player)).to eq player
      end

      it "renders the :show view" do
        player = create(:player)
        get :show
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
  end

  describe "guest access to players" do
    it_behaves_like "public access to players"
  end
end


