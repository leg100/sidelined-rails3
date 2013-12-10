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

  # GET /players/typeahead.json
  def typeahead
    @players = Player.all.map{|p| 
      { name: p.long_name, 
        short_name: p.short_name, 
        value: p.short_name,
        slug: p.slug,
        tokens: [p.forenames, p.surnames, p.short_name].flatten }
    }
    render :json => @players
  end

  # POST /players/search/
  #{
  #  slug: <slug>,
  #  short_name: <short_name>
  #}
  def search
    @player = if params[:slug].empty? 
      Player.where(short_name: params[:short_name]).first
    else
      Player.find(params[:slug])
    end

    if @player
      redirect_to player_path(@player)
    else
      player_not_found
    end
  end


private
 def player_not_found
    flash[:alert] = "Cannot find player"
    redirect_to :back
  end
end
