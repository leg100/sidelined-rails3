class PlayersController < ApplicationController
  autocomplete :player, 
    :name, 
    :display_value => :long_name, 
    :full => true, 
    :column_name => 'long_name', 
    :extra_data => [:slug]

  def index
    @players = Player.all
    respond_to do |format|
      format.json { render :json => @players }
      format.html { render :html => @players }
    end
  end

  def show
    @player = Player.find(params[:id])
    respond_to do |format|
      format.json { render :json => @player }
      format.html { render :html => @player }
    end
  end

  # POST /players/search/
  def search
    @player = Player.find(params[:slug])
    redirect_to player_path(@player)
  end
end
