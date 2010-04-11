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
    cookies[:remember_token] = sha1
    user.remember_token = sha1
    user.save
    @current_user = user
  end

  # call this if you want to log someone out
  def unset_current_user
    current_user.remember_token = nil
    cookies[:remember_token] = nil
    current_user.save
  end


  def logged_in?
    # make sure we have a user from the remember_token 
    redirect_to(login_path) if current_user.nil?

    # ensure this user has actually purchased
    redirect_to(purchase_path) if current_user.purchase_token.nil?
  end

end
