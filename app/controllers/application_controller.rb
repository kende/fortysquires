class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :current_user
  def current_user
# TODO:    @current_user ||= User.find_by_remember_token(cookies[:remember_token])
    @current_user = User.first
  end


  def logged_in?
    redirect_to(login_path) if current_user.nil?
  end

end
