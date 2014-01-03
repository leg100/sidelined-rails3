class Api::InjuriesController < ApplicationController
  before_filter :authenticate_user!, :only => [:create, :update, :destroy]

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

  def update
    @injury = Injury.find(params[:id])

    respond_to do |format|
      if @injury.update_attributes(params[:injury])
        format.json { head :no_content }
      else
        format.json { render json: @injury.errors, status: :unprocessable_entity }
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
    @injuries = Injury.includes(:modifier).desc(:updated_at)
      .page(page)

    respond_to do |format|
      format.html # index.html.erb
      format.json { 
        render json: @injuries,
          meta: {total: @injuries.length }
      }
    end
  end
end
