class UsersController < ApplicationController
  include ApplicationHelper

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
      flash[:alert] = []
      if @user.errors.present?
        @user.errors.each do |key, value|
          if key.to_s == "full_name"
            flash[:alert] << "Full name can't be blank"
          else
            flash[:alert] << key.to_s.capitalize + " " + value   
          end
        end
      end
      respond_to do |format|
        format.html { render :new }
        # format.json { render json: flash[:alert], status: :failed}
        format.js { render :create}
      end
    end 
  end

  def show
    @user = User.find_by(id: params[:id])
  end

  def index
    @users = User.all
    search_params.each do |key, value|
      if value.present?
        @users = @users.send(key, value)
      end
    end
    # if search_params["full_name"].present?
    #   @user = User.find_by_full_name(search_params["full_name"])
    # end
    # byebug
  end

  private

  def user_params
    params.require(:user).permit(:full_name, :email, :password, :photo)
  end

  def search_params
    params.require(:q).permit(:full_name, :country, :gender)
  end
end
