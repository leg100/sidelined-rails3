class Users::SessionsController < Devise::SessionsController

  def get_current_user
    render json: current_user
  end
end
