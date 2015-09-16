class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  #before_action
  #before_action :authenticate_male!
  #before_action :authenticate_lady_doctor!

  def after_sign_in_path_for(resource)
    case resource
    when Male
      males_path
    when LadyDoctor
      lady_doctors_path
    when Admin
      admins_path      
    end
  end

end

