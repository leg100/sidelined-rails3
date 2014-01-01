class Api::HistoryTrackersController < ApplicationController
  def index
    @trackers = HistoryTracker.includes(:modifier).desc(:updated_at)
      .page(params[:page])

    render json: @trackers,
      meta: {total: @trackers.length }
  end
end
