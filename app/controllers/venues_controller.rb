class VenuesController < ApplicationController
  before_filter :logged_in?

  def search
    @q = CGI.escapeHTML(params[:q])
    v = current_user.foursquare.venues(:q => @q, 
                                       :geolat => params[:lat], 
                                       :geolong => params[:long])
    @venues = v.andand["groups"].andand[0].andand["venues"] || []
  end

end
