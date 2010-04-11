class UsersController < ApplicationController

  def oauth_authorize
    @request_token = oauth.request_token
    session[:request_token] = @request_token.token
    session[:request_secret] = @request_token.secret
    redirect_to @request_token.authorize_url
  end

  def oauth_callback
    @user = User.new_from_access_token(*oauth.authorize_from_request(session[:request_token], session[:request_secret], params[:oauth_token]))

    if @user.save
      set_current_user(@user)
      if @user.purchase_token.nil?
        if cookies[:purchase_token].blank?
          flash[:notice] = "Great! Step 1 of 2 complete. Now you just need to purchase the app (it only costs $0.99)."
          redirect_to(purchase_path) and return
        else
          token = PurchaseToken.new(:purchase_token => cookies[:purchase_token], :user_id => @user.id)
          if token.save
            flash[:notice] = "Awesome, you've logged in and purchased. Now check in!"
            redirect_to(checkin_path) and return
          else
            flash[:error] = "Your purchase wasn't valid for some reason. Please try again."
            redirect_to(purchase_path) and return
          end
        end
      else
        flash[:notice] = "w00t. You're fortysquiring! Enjoy."
        redirect_to(checkin_path) and return
      end
    else
      flash[:error] = "Sorry, we were unable to authenticate you with Foursquare. Please try again."
      redirect_to(signup_path) and return
    end
  end

  private
  def oauth
    Foursquare::OAuth.new(OAUTH_KEY, OAUTH_SECRET)
  end
end
