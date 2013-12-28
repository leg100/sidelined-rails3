class InjuriesController < ApplicationController

  def create
    # workaround for https://github.com/aq1018/mongoid-history/issues/26
    @injury = Injury.new(params[:injury].merge(modifier: current_user))

    respond_to do |format|
      if @injury.save
        format.json { render json: @injury, status: :created}
      else
        format.json { render json: @injury.errors, status: :unprocessable_entity }
      end
    end
  end
end
