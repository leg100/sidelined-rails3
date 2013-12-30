class Api::ClubsController < ApplicationController
  def index 
    @clubs = Club.all
    respond_to do |format|
      format.json { render :json => @clubs }
    end
  end
end
