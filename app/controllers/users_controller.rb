class UsersController < ApplicationController

  def oauth_authorize
    @request_token = oauth.request_token
    session[:request_token] = @request_token.token
    session[:request_secret] = @request_token.secret
    redirect_to @request_token.authorize_url
  end

  def oauth_callback
    @user = User.new_from_access_token(*oauth.authorize_from_request(session[:request_token], session[:request_secret], params[:oauth_token]))
    puts "!!!!! @user: #{@user.inspect}"

    if @user.save
      set_current_user(@user)
      puts "current_user: #{current_user.inspect}"
      flash[:notice] = "w00t. You're fortysquiring! Enjoy."
      redirect_to checkin_path
    else
      flash[:error] = "Sorry, we were unable to authenticate you with Foursquare. Please try again."
      redirect_to signup_path
    end
  end

  private
  def oauth
    Foursquare::OAuth.new(OAUTH_KEY, OAUTH_SECRET)
  end
end
