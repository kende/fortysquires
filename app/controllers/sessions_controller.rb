class SessionsController < ApplicationController
  def new
    redirect_to(checkin_path) and return unless current_user.nil?
    @title = "Login"
  end

  def logout
    unset_current_user
    redirect_to root_path
  end

end
