class Api::EventsController < ApplicationController
  before_filter :authenticate_user!, :only => [:create, :update, :destroy]
  before_filter :require_params, :only => [ :index ]

  def create
    # workaround for https://github.com/aq1018/mongoid-history/issues/26
    @event = Event.new(params[:event].merge(modifier: current_user))
    logger.debug(@event)

    respond_to do |format|
      if @event.save
        format.json { render json: @event, status: :created}
      else
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @event = Event.find(params[:id])

    respond_to do |format|
      if @event.update_attributes(params[:event])
        format.json { head :no_content }
      else
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @event = Event.find(params[:id])
    @event.destroy

    render json: @event
  end

  def index
    @events = Event.includes(:modifier).desc(:updated_at)
      .page(params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.json { 
        render json: @events,
          meta: {total: @events.length }
      }
    end
  end

private
  def require_params
    return unless params[:page].blank?
    render status: 200, json: {
      success: false,
      info: 'Missing page number',
      data: {}
    }
  end
end
