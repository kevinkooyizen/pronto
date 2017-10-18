class UsersController < ApplicationController
  include ApplicationHelper
  include SessionsHelper

  def new
    @user = User.new
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
        format.js { render :create}
      end
    end 
  end

  def show
    @user = User.find_by(id: params[:id])
  end

  def index
    @users = User.all
    if params[:q].present?
      search_params.each do |key, value|
        if value.present?
          @users = @users.send(key, value)
        end
      end
    end
  end

  def edit
    @user = User.find_by(id: params[:id])
  end

  def update
    @user = User.find_by(id: params[:id])
    @user.update(user_params)
    if @user.save
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
        format.html { render :edit }
        format.js { render :update}
      end
    end
  end

  private

  def user_params
    params.require(:user).permit(:full_name, :email, :password, :photo)
  end

  def search_params
    params.require(:q).permit(:full_name, :country, :gender)
  end
end
