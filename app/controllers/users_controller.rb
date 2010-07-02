class UsersController < ApplicationController

  def oauth_authorize
    o = oauth
    o.set_callback_url(oauth_callback_url(:host => "fortysquires.com"))
    o.consumer.options[:authorize_path] = "/mobile/oauth/authorize"
    @request_token = o.request_token
    session[:request_token] = @request_token.token
    session[:request_secret] = @request_token.secret
    redirect_to @request_token.authorize_url
  end

  def oauth_callback
    begin
      logger.info "request_token: #{session[:request_token].inspect}, secret: #{session[:request_secret].inspect}, token: #{params[:oauth_token].inspect}, verifier: #{params[:oauth_verifier].inspect}"
      @user = User.new_from_access_token(*oauth.authorize_from_request(session[:request_token], session[:request_secret], params[:oauth_verifier]))
    rescue
      flash[:error] = "Sorry, we were unable to authenticate you with Foursquare. Please try again."
      redirect_to(login_path) and return
    end

    if @user.save
      set_current_user(@user)
      if @user.purchase_token.nil?
        if cookies[:purchase_token].blank?
          flash[:notice] = "Great! Step 1 of 2 complete. Now you just need to purchase the app (it only costs $0.99)."
          redirect_to(purchase_path) and return
        else
          token = PurchaseToken.new(:token => cookies[:purchase_token], :user_id => @user.id)
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
      redirect_to(login_path) and return
    end
  end

  private
  def oauth
    Foursquare::OAuth.new(OAUTH_KEY, OAUTH_SECRET)
  end
end
