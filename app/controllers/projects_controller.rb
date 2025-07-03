class ProjectsController < ApplicationController
  before_action :authorize_request
  before_action :admin_only, only: [:create, :update, :destroy]

  def index
    if @current_user.role == 'manager'
      project_ids = Task.where(user_id: @current_user.id).pluck(:project_id).uniq
      projects = Project.where(id: project_ids)
      render json: projects
    else
      render json: { error: 'NO ACCESS' }, status: :no_access
    end
  end

  def show
    project = Project.find(params[:id])
    render json: project
  end

  def create
    project = current_user.projects.build(project_params)

    if project.start_date < project.end_date && project.save
      render json: project, status: :created
    else
      render json: { errors: project.errors.full_messages }, status: :invalid
    end
  end

  def update
    project = Project.find(params[:id])
    if project.update(project_params) && project.start_date < project.end_date
      render json: project
    else
      render json: { errors: project.errors.full_messages }, status: :invalid
    end
  end

  def destroy
    project = Project.find(params[:id])
    project.destroy
    render json: { message: 'Project deleted successfully' }, status: :ok
  end

  private

  def project_params
    params.permit(:name, :desc, :start_date, :end_date)
  end

  def admin_only
    render json: { error: 'Only admin can perform this action' }, status: :unauthorized unless @current_user.role == 'admin'
  end
end
