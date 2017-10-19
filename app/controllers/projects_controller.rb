class ProjectsController < ApplicationController
  include ApplicationHelper

  def index
    @projects = Project.all
    if params[:q].present?
      search_params.each do |key, value|
        if value.present?
          if key == "name"
            key = "tname"
          end
          @projects = @projects.send(key, value)
        end
      end
    end
  end

  def new
    @project = Project.new
  end

  def create
    @user = current_user
    @project = Project.new(project_params)
    @project.user = current_user
    if @project.save
      redirect_to project_path(@project)
    else
      flash[:alert] = []
      if @project.errors.present?
        @project.errors.each do |key, value|
          flash[:alert] << key.to_s.capitalize + " " + value   
        end
      end
      render 'new'
    end
  end

  def show
    @project = Project.find_by_id(params[:id])
  end

  def edit
    @project = Project.find_by_id(params[:id])
  end

  def update
    @project = Project.find_by_id(params[:id])
    @project.update(project_params)
    if @project.save
      redirect_to project_path(@project)
    else
      render 'edit'
    end
  end

  def destroy
    @project = Project.find_by_id(params[:id])
    @project.destroy
    redirect_to user_path(current_user)
  end


  private

  def project_params
    params.require(:project).permit(:name, :language, :description, {images: []})
  end

  def search_params
    params.require(:q).permit(:name, :description)
  end
end
