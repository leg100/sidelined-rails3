class Api::FixturesController < ApplicationController
  before_filter :authenticate_user!, :only => [:new, :edit, :create, :destroy]
  skip_before_filter :verify_authenticity_token, :if => Proc.new { |c| c.request.format == 'application/json' }
  
  # GET /fixtures
  # GET /fixtures.json
  def index
    @fixtures = Fixture.all

    respond_to do |format|
      format.json { render json: @fixtures }
    end
  end

  # GET /fixtures/1
  # GET /fixtures/1.json
  def show
    @fixture = Fixture.find(params[:id])

    respond_to do |format|
      format.json { render json: @fixture }
    end
  end

  # GET /fixtures/new
  # GET /fixtures/new.json
  def new
    @fixture = Fixture.new

    respond_to do |format|
      format.json { render json: @fixture }
    end
  end

  # GET /fixtures/1/edit
  def edit
    @fixture = Fixture.find(params[:id])
  end

  # POST /fixtures.json
  def create
    @fixture = Fixture.new(fixture_params)

    # workaround for https://github.com/aq1018/mongoid-history/issues/26
    @fixture.modifier = current_user
    
    respond_to do |format|
      if @fixture.save
        return render json: @fixture, status: :created
      else
        return render json: @fixture.errors.full_messages, status: :unprocessable_entity
      end
    end
  end

  # PUT /fixtures/1
  # PUT /fixtures/1.json
  def update
    @fixture = Fixture.find(params[:id])

    respond_to do |format|
      if @fixture.update_attributes(fixture_params)
        format.json { head :no_content }
      else
        format.json { render json: @fixture.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /fixtures/1
  # DELETE /fixtures/1.json
  def destroy
    @fixture = Fixture.find(params[:id])
    @fixture.destroy

    respond_to do |format|
      format.json { head :no_content }
    end
  end

private
  # Using a private method to encapsulate the permissible parameters is just a good pattern
  # since you'll be able to reuse the same permit list between create and update. Also, you
  # can specialize this method with per-user checking of permissible attributes.
  def fixture_params
    params.require(:fixture).permit(:datetime, :home_club_id, :away_club_id)
  end
end
