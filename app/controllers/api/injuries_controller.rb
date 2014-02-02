class Api::InjuriesController < ApplicationController
  before_filter :authenticate_user!, :only => [:create, :update, :destroy, :revert]

  def create
    @injury = Injury.new(injury_params)
    # workaround for https://github.com/aq1018/mongoid-history/issues/26
    @injury.modifier = current_user

    respond_to do |format|
      if @injury.save
        format.json { render json: @injury, status: :created}
      else
        format.json { render json: @injury.errors.full_messages, status: :unprocessable_entity }
      end
    end
  end
  # GET /api/injuries/current?player_id=:player_id
  def current
    @player = Player.find(params[:player_id])

    if @player.injured?
      render json: @player.current_injury, status: :ok
    else
      render json: false, status: :not_found
    end
  end
  #
  # POST /api/injuries/:id/revert
  # data: {version: old_version}
  def revert
    params.require(:injury).permit(:version)
    @injury = Injury.find(params[:id])
    revert_to_version = params[:injury][:version] + 1

    begin
      @injury.undo!(
        current_user, {
        from: @injury.version,
        to: revert_to_version
      })
    rescue Mongoid::Errors::Validations
      return render json: {
        info: "Cannot revert; version #{@injury.version} has a different schema",
      }, status: :unprocessable_entity
    rescue Exception => e
      return render json: {
        info: "Unknown error occurred",
        err: e.message
      }, status: :unprocessable_entity
    else
      return render json: @injury, status: 200
    end
  end

  def update
    @injury = Injury.find(params[:id])

    respond_to do |format|
      if @injury.update_attributes(injury_params.merge(modifier: current_user))
        format.json { render json: @injury, status: :ok }
      else
        format.json { render json: @injury.errors.full_messages, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @injury = Injury.find(params[:id])
    @injury.destroy

    render json: @injury
  end

  def show
    @injury = Injury.find(params[:id])

    render json: @injury
  end

  def index
    page = params[:page] || 1
    per_page = params[:per_page] || 10

    query = if params.key?(:statuses) 
      statuses = params[:statuses].split('|')
      Injury.in(status: statuses)
    else 
      Injury.all
    end
  
    @injuries = query.includes(:modifier, :player).desc(:updated_at)
      .page(page).per(per_page)

    respond_to do |format|
      format.html # index.html.erb
      format.json { 
        render json: @injuries,
          meta: {total: @injuries.length },
          each_serializer: InjuryArraySerializer
      }
    end
  end

private
  # Using a private method to encapsulate the permissible parameters is just a good pattern
  # since you'll be able to reuse the same permit list between create and update. Also, you
  # can specialize this method with per-user checking of permissible attributes.
  def injury_params
    params.require(:injury).permit(:source, :quote, :return_date, :status, :player_id, :body_part)
  end
end
