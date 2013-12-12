class PlayersController < ApplicationController
  before_filter :authenticate_user!, :only => [:new, :edit, :create, :destroy]
  skip_before_filter :verify_authenticity_token, :if => Proc.new { |c| c.request.format == 'application/json' }

  # POST /players
  # POST /players.json
  def create
    # workaround for https://github.com/aq1018/mongoid-history/issues/26
    @player = Player.new(params[:player].merge(modifier: current_user))
    logger.debug(@player)

    respond_to do |format|
      if @player.save
        format.html { redirect_to @player, notice: 'Player was successfully created.' }
        format.json { render json: @player, status: :created, location: @player }
      else
        format.html { render action: 'new' }
        format.json { render json: @player.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /players/1
  # PUT /players/1.json
  def update
    @player = Player.find(params[:id])

    respond_to do |format|
      if @player.update_attributes(params[:player])
        format.html { redirect_to @player, notice: 'Player was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @player.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /fixtures/1
  # DELETE /fixtures/1.json
  def destroy
    @player = Player.find(params[:id])
    @player.destroy

    respond_to do |format|
      format.html { redirect_to players_url }
      format.json { head :no_content }
    end
  end

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
        tokens: p.tokens
      }
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
