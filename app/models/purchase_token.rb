class PurchaseToken < ActiveRecord::Base
  belongs_to :user

  validates_presence_of :token

  before_save :verify_with_ashq

  def verify_with_ashq
    u = "http://www.appstorehq.com/apps/buy/verify?purchase_token=#{CGI.escape(token)}&app_id=196344"
    resp = HTTParty.get(u)
    resp.code == 200
  end

end
