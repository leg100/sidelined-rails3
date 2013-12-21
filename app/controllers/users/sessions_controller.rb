class Users::SessionsController < Devise::SessionsController

  skip_before_filter :verify_authenticity_token
  before_filter :require_params, :only => [ :create ]
  respond_to :json
  prepend_before_filter :require_no_authentication, :only => [ :new ]

  def create
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

private
  def require_params
    return unless params[:user][:login].blank?
    return unless params[:user][:password].blank?
    render status: 200, json: {
      success: false,
      info: 'Missing credentials',
      data: {}
    }
  end
end
