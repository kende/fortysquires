class User < ActiveRecord::Base

  def foursquare
    return @foursquare if @foursquare
    oauth = Foursquare::OAuth.new(OAUTH_KEY, OAUTH_SECRET)
    oauth.authorize_from_access(access_token, access_secret)
    @foursquare ||= Foursquare::Base.new(oauth)
  end
end
