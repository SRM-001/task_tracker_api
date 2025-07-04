module Mutations
  class CreateTask < BaseMutation
    argument :project_id, ID, required: true
    argument :title, String, required: true
    argument :desc, String, required: false
    argument :status, String, required: true
    argument :due_date, GraphQL::Types::ISO8601Date, required: true
    argument :priority, Integer, required: false

    field :task, Types::TaskType, null: true
    field :errors, [String], null: false

    def resolve(args)
      user = context[:current_user]
      return unauthorized unless user

      project = Project.find_by(id: args[:project_id])
      return error("Project not found") unless project

      if args[:due_date] > project.end_date
        return error("Task due date cannot be after project end date")
      end

      task = project.tasks.new(
        title: args[:title],
        desc: args[:desc],
        status: args[:status],
        due_date: args[:due_date],
        priority: args[:priority],
        user_id: user.id
      )

      if task.save
        { task: task, errors: [] }
      else
        { task: nil, errors: task.errors.full_messages }
      end
    end

    private

    def unauthorized
      raise GraphQL::ExecutionError, "Unauthorized"
    end

    def error(msg)
      { task: nil, errors: [msg] }
    end
  end
end
