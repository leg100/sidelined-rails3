class Api::Users::ConfirmationsController < Devise::ConfirmationsController

  skip_before_filter :verify_authenticity_token

  def create
    super
  end

  def new
    super
  end

  def show
    self.resource = resource_class.confirm_by_token(params[:confirmation_token])

    if resource.errors.empty?
      redirect_to '/confirmed?status=success'
    else
      if resource.errors.full_messages.length > 0
        redirect_to "/confirmed?status=failure&errors=#{resource.errors.full_messages}"
      else
        redirect_to "/confirmed?status=failure"
      end
    end
  end
end
