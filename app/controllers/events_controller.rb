class EventsController < ApplicationController
 def index
    @events = Event.includes(:modifier).all.sort_by{|e| e.updated_at}
    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @events }
    end
  end
end
