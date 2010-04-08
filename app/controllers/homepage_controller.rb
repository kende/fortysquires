class HomepageController < ApplicationController
  def index
    redirect_to(checkin_path) and return if current_user
  end

end
