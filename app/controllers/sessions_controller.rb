class SessionsController < ApplicationController
  include SessionsHelper
  def create_from_omni_auth
    auth_hash = request.env["omniauth.auth"]
    authentication = Authentication.find_by_provider_and_uid(auth_hash["provider"], auth_hash["uid"]) || Authentication.create_with_omniauth(auth_hash)

    # if: previously already logged in with OAuth
    if authentication.user
      user = authentication.user
      authentication.update_token(auth_hash)
      @next = root_url
      @notice = "Signed in!"
    # else: user logs in with OAuth for the first time
    else
      user = User.create_with_auth_and_hash(authentication, auth_hash)

      # you are expected to have a path that leads to a page for editing user details
      @next = user_path(user)
      @notice = "User created."
    end

    sign_in(user)
    redirect_to @next, :notice => @notice
  end

  def new
    render template: "sessions/new"
  end

  def create
    @user = authenticate(user_params[:email], user_params[:password])
    
    if !@user.nil?
      sign_in(@user)
      redirect_to user_path(@user)
    else
      flash.now.notice = "Wrong email or password"
      render template: "sessions/new", status: :unauthorized
    end
  end

  def destroy
    helpers.sign_out
    redirect_to root_path
  end

  def user_params
    params.require(:session).permit(:email, :password)
  end
end