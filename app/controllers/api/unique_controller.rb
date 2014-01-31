class Api::UniqueController < ApplicationController
 
  # params: object, name, value
  def check_availability
    query = { params[:name] => params[:value] }
    logger.debug query
    if params[:object].capitalize.constantize.send(:where, query).exists?
      logger.debug "409"
      return render status: 409, json: { success: false, info: "#{params[:name]} taken." }
    else
      logger.debug "200"
      return render status: 200, json: { success: true, info: 'available' } 
    end
  end
end
