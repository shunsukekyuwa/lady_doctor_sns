class Males::SessionsController < Devise::SessionsController
# before_filter :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  def new
     super
     #redirect_to new_male_session_path
  end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  def destroy
    p 'fuga'
    super
  end

  # protected

  # You can put the params you want to permit in the empty array.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.for(:sign_in) << :attribute
  # end

  def after_sign_out_path_for(resource)
    case resource
    when :male
      p 'hoge'
      new_male_session_path
    when :lady_doctor
      new_lady_doctor_session_path
    #when Admin
    end
  end 
end
