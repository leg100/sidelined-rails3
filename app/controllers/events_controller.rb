class EventsController < ApplicationController
  before_filter :require_params, :only => [ :index ]

  def index
    @events = Event.includes(:modifier).desc(:updated_at)
      .asc(:pageid).page(params[:page])

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
