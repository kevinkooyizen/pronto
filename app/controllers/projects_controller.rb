class ProjectsController < ApplicationController
  include ApplicationHelper

  def new
    @project = Project.new
  end

  def create
    @user = current_user
    @project = Project.new(project_params)
    @project.user = current_user
    if @project.save
      if params[:project][:images].present? 
        params[:project][:images].each do |item|
          Cloudinary::Uploader.upload(item)
        end
      end
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
    params.require(:project).permit(:name, :language, {images: []})
  end
end
