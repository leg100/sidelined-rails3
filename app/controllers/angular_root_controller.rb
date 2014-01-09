class AngularRootController < ApplicationController
  respond_to :html
  def show
    render :file => 'public/index.html', :layout => false
  end
end
