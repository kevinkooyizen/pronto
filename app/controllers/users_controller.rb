class UsersController < ApplicationController
  include SessionsHelper

  def new
    @user = User.new
    render template: "users/new"
  end

  def create
    @user = User.new(user_params)

    if @user.save
      sign_in @user
      redirect_to user_path(@user)
    else
      render template: "users/new"
    end
  end

  def show
    @user = User.find_by(id: params[:id])
  end

  private

  def user_params
    params.require(:session).permit(:full_name, :email, :password, :photo)
  end
end
