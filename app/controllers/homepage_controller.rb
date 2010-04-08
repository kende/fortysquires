class HomepageController < ApplicationController
  def index
    # TODO: fix me for actual sessions!
    if current_user && !params[:logged_out]
      redirect_to checkin_path and return
    end

    
  end

end
