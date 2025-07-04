# frozen_string_literal: true

module Types
  class QueryType < Types::BaseObject
    field :projects, [ProjectType], null: false, description: "Fetch all projects"

    def projects
      Project.all
    end

    field :tasks_by_project, [TaskType], null: false do
      description "Fetch tasks for a specific project"
      argument :project_id, ID, required: true
    end

    def tasks_by_project(project_id:)
      Task.where(project_id: project_id)
    end

    field :projects_by_manager, [ProjectType], null: false do
      description "Fetch all projects and their tasks for a manager"
      argument :user_id, ID, required: true
    end

    def projects_by_manager(user_id:)
      Project.includes(:tasks).where(user_id: user_id)
    end

    field :projects_and_tasks_by_manager, [Types::ProjectType], null: false do
      description "Fetch all projects and their tasks assigned to the current manager"
    end

    def projects_and_tasks_by_manager
      raise GraphQL::ExecutionError, "Not authorized" unless context[:current_user]

      context[:current_user].projects.includes(:tasks)
    end

    field :me, Types::UserType, null: true, description: "Returns the current user"

    def me
      context[:current_user]
    end
  end
end
