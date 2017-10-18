class SessionsController < ApplicationController
  include SessionsHelper
  def create_from_omni_auth
    auth_hash = request.env["omniauth.auth"]
    
    authentication = Authentication.find_by_provider_and_uid(auth_hash["provider"], auth_hash["uid"]) || Authentication.create_with_omniauth(auth_hash)
    
    # if: previously already logged in with OAuth
    if authentication.user
      user = authentication.user
      authentication.update_token(auth_hash)
      @next = user_path(user)
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
  end

  def create
    @user = authenticate(user_params[:email], user_params[:password])
    
    if @user.present?
      sign_in(@user)
      redirect_to user_path(@user)
    else
      flash[:alert] = []
      if !params[:session][:email].present?
        flash[:alert] << "Please enter an email."
      end
      if !params[:session][:password].present?
        flash[:alert] << "Please enter a password."
      end
      if params[:session][:email].present? && params[:session][:password].present?
        flash[:alert] << "Invalid email or password."
      end
      respond_to do |format|
        format.html { render :new }
        format.js { render :create }
      end
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