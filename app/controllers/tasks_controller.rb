class TasksController < ApplicationController
  before_action :authorize_request
  before_action :set_project, only: [:index, :create]
  before_action :set_task, only: [:update, :destroy]

  def index
    tasks = @project.tasks
    render json: tasks
  end

  def create
    task = @project.tasks.build(task_params.merge(user_id: @current_user.id))

    if task.due_date > @project.end_date
      render json: { error: "Task due date cannot be after project end date" }, status: :unprocessable_entity
    elsif task.save
      render json: task, status: :created
    else
      render json: { errors: task.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @task.update(task_params)
      # TODO: Add ActionCable notification here
      render json: @task
    else
      render json: { errors: @task.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @task.destroy
    render json: { message: "Task deleted" }, status: :ok
  end

  private

  def set_project
    @project = Project.find(params[:project_id])
  rescue
    render json: { error: "Project not found" }, status: :not_found
  end

  def set_task
    @task = Task.find(params[:id])
  rescue
    render json: { error: "Task not found" }, status: :not_found
  end

  def task_params
    params.permit(:title, :desc, :status, :due_date, :priority)
  end
end
