class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :current_user
  def current_user
    return @current_user if @current_user
    return nil if cookies[:remember_token].blank?
    @current_user = User.find_by_remember_token(cookies[:remember_token])
  end

  # call this method if you want to log someone in
  def set_current_user(user)
    sha1 = Digest::SHA1.hexdigest(user.id.to_s + Time.now.to_i.to_s)
    cookies[:remember_token] = { :value => sha1, :expires => 3.years.from_now }
    user.remember_token = sha1
    user.save
    @current_user = user
  end

  # call this if you want to log someone out
  def unset_current_user
    unless current_user.nil?
      current_user.remember_token = nil
      current_user.save
    end
    cookies[:remember_token] = nil
  end


  def logged_in?
    redirect_to(login_path) and return if current_user.nil?

    # ensure this user has actually purchased
    redirect_to(purchase_path) and return if current_user.purchase_token.nil?
  end

end
