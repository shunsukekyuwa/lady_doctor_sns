module MalesHelper
  def sign_in(male)
    remember_token = Male.new_remember_token
    cookies.permanent[:remember_token] = remember_token
    male.update_attribute(:remember_token, Male.encrypt(remember_token))
    self.current_male = male
  end

  def signed_in?
    !current_male.nil?
  end

  def current_male
    remember_token = Male.encrypt(cookies[:remember_token])
    @current_male ||= Male.find_by(remember_token: remember_token)
  end

  def current_male?(male)
    male == current_male
  end

  def current_male=(male)
    @current_male = male
  end

  def sign_out
    self.current_user = nil
    cookies.delete(:remember_token)
  end

  def signed_in_user
      redirect_to signin_url, notice: "Please sign in." unless signed_in?
  end

end
