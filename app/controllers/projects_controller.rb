class ProjectsController < ApplicationController
  include ApplicationHelper

  def index
    @projects = Project.all
    search_params.each do |key, value|
      if value.present?
        if key == "name"
          key = "tname"
        end
        @projects = @projects.send(key, value)
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
      render 'new'
    end
  end

  def show
    @project = Project.find_by_id(params[:id])
  end

  def destroy
  end


  private

  def project_params
    params.require(:project).permit(:name, :language, :description, {images: []})
  end

  def search_params
    params.require(:q).permit(:name, :description)
  end
end
