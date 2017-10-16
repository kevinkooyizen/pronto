class StaticController < ApplicationController
  def home
    @user = User.ransack(params[:user]) 
    @people = @user.result(distinct: true)
    @project = Project.ransack(params[:project]) 
    @projects = @project.result(distinct: true)
  end
end
