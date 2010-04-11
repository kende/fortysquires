class User < ActiveRecord::Base
  before_validation :set_foursquare_id
  validates_presence_of :foursquare_id
  validates_uniqueness_of :foursquare_id

  has_one :purchase_token

  def foursquare
    return @foursquare if @foursquare
    oauth = Foursquare::OAuth.new(OAUTH_KEY, OAUTH_SECRET)
    oauth.authorize_from_access(access_token, access_secret)
    @foursquare ||= Foursquare::Base.new(oauth)
  end

  # get a user's foursquare_id from the API, not our DB
  def api_foursquare_id
    self.foursquare.user["id"]
  end

  def set_foursquare_id
    self.foursquare_id = api_foursquare_id unless self.foursquare_id
  end

  def self.new_from_access_token(access_token, access_secret)
    user = User.new(:access_token => access_token, :access_secret => access_secret)

    if u2 = User.find_by_foursquare_id(user.api_foursquare_id)
      u2.access_token  = access_token
      u2.access_secret = access_secret
      user = u2
    end

    user
  end

end
