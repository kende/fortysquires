class PurchaseTokensController < ApplicationController

  def purchase
    @purchase_url = "http://www.appstorehq.com/fortysquires-mobilewebfoursquareclient-html5web-196344/app/buy"
  end

  def callback
    if params[:purchase_token].blank?
      flash[:error] = "There was an error processing your request. Please try logging in and purchasing again."
      redirect_to(login_path) and return
    end

    if current_user.nil?
      cookies[:purchase_token] = params[:purchase_token]
      redirect_to(login_path) and return
    end

    @purchase_token = PurchaseToken.new(:token => params[:purchase_token],
                                        :user_id => current_user.id)

    if @purchase_token.save
      flash[:notice] = "Thanks for your purchase. Now get checkin' in!"
      redirect_to checkin_path
    else
      flash[:error] = "Sorry. The purchase token you supplied wasn't valid. Please try purchasing again."
      redirect_to login_path
    end
  end
end
