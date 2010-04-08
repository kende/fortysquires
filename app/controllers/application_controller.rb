class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :current_user
  def current_user
    # TODO: make sessions actually work!
    if params[:logged_out]
      @current_user = nil
    else
      @current_user = User.first
    end
    @current_user
  end


  def logged_in?
    redirect_to(login_path) if current_user.nil?
  end

end
