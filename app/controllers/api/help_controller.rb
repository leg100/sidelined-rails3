class Api::HelpController < ApplicationController

  # POST /api/help/send_message
  def send_message
    begin 
      HelpMailer.forward_message(help_params).deliver
    rescue Exception => e
      # not sure when this would ever happen.....
      render :json => 'error', :status => :unprocessable_entity
    else
      render :json => {}, :status => :created
    end
  end

private
  def help_params
    params.require(:help).permit(:email, :message)
  end
end
