class UniqueController < ApplicationController
  # params: object, name, value
  def check_availability
    query = { params[:name] => params[:value] }
    if params[:object].capitalize.constantize.send(:where, query).exists?
      return render status: 409, json: { success: false, info: "#{params[:name]} taken." }
    else
      return render status: 200, json: { success: true, info: 'available' } 
    end
  end
end
