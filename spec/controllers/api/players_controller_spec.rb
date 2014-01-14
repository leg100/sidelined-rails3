require 'spec_helper'

describe Api::PlayersController do
  shared_examples("public access to players") do
    describe "GET #show" do
      it "assigns the requested player to @player" do
        player = create(:player)
        get :show, id: player, format: :json
        expect(assigns(:player)).to eq player
      end
    end

    describe "GET #index" do
      it "populates an array of players" do
        player = create(:player)
        get :index, format: :json

        serialized_response = { 
          players: [{
            id: player.id,
            long_name: player.long_name,
            short_name: player.short_name,
            ticker_and_name: player.short_name + ' ' + player.long_name
          }]
        }
        expect(response.body).to eq serialized_response.to_json
      end
    end

    describe "POST #create" do
      it "creates a player" do
        expect {
          post :create, player: create(:player)
        }.to change(Player, :count).by(1)
      end
    end
  end

  describe "guest access to players" do
    it_behaves_like "public access to players"
  end
end


