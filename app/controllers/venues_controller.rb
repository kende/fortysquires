class VenuesController < ApplicationController
  before_filter :logged_in?

  def search
    @q = CGI.escapeHTML(params[:q])
    v = current_user.foursquare.venues(:q => CGI.escape(params[:q]), 
                                       :geolat => params[:lat], 
                                       :geolong => params[:long])
    if v.blank?
      @venues = []
    else
      @venues = v.andand["groups"].andand[0].andand["venues"] || []
    end
  end

end
