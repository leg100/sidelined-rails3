class Api::Users::RegistrationsController < Devise::RegistrationsController

  skip_before_filter :verify_authenticity_token
  respond_to :json

  def create
    build_resource(user_params)

    if resource.save
      sign_in(:user, resource)

      return render status: 200, json: {
        success: true,
        info: 'Signed up',
        data: resource
      }
    else 
      return failure(resource.errors)
    end
  end

  def failure(errors='')
    return render status: 200,
      json: {
        success: false, 
        info: 'Login Failed',
        data: errors
      }
  end

private
  # Using a private method to encapsulate the permissible parameters is just a good pattern
  # since you'll be able to reuse the same permit list between create and update. Also, you
  # can specialize this method with per-user checking of permissible attributes.
  def user_params
    params.require(:user).permit(:username, :email, :password, :password_confirmation)
  end
end
