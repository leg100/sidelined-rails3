class Users::SessionsController < Devise::SessionsController

  skip_before_filter :verify_authenticity_token

  respond_to :json

  def create
    logger.debug(params)
    resource = User.find_for_database_authentication(
      login: params[:user][:login]
    )

    return failure unless resource
    return failure unless resource.valid_password?(params[:user][:password])

    sign_in(:user, resource)
    return render status: 200,
      json: {
        success: true,
        info: 'Logged in',
        data: resource
      }
  end

  def destroy
    sign_out(:user)
    return render status: 200,
      json: {
        success: true,
        info: 'Logged out',
        data: {}
      }
  end

  def get_current_user
    render json: current_user
  end

  def failure
    return render status: 200,
      json: {
        success: false, 
        info: 'Login Failed',
        data: {}
      }
  end
end
