class PlayersController < ApplicationController
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
end
