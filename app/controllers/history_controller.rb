class HistoryController < ApplicationController
  before_filter :logged_in?

  def index
    @title = "Your History"
    @history = current_user.foursquare.history
  end

end
