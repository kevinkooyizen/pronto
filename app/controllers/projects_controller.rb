class ProjectsController < ApplicationController
  include ApplicationHelper

  def new
    @project = Project.new
  end

  def create
    @user = current_user
    @project = Project.new(project_params)
  end

  def destroy
  end

  private

  def project_params
    params.require(:project).permit(:name, images: [])
  end
end
