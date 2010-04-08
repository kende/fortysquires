class UsersController < ApplicationController

  def oauth_authorize
    @request_token = oauth.request_token
    session[:request_token] = @request_token.token
    session[:request_secret] = @request_token.secret
    redirect_to @request_token.authorize_url
  end

  def oauth_callback
    at, as = oauth.authorize_from_request(session[:request_token], session[:request_secret], params[:oauth_token])

    @user = User.new(:access_token => at, :access_secret => as)
    if @user.save
      session[:user] = @user
      flash[:notice] = "w00t. You're fortysquiring! Enjoy."
      redirect_to history_path
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
