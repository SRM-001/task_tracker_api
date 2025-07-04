module Mutations
  class UpdateTask < BaseMutation
    argument :id, ID, required: true
    argument :desc, String, required: false
    argument :due_date, GraphQL::Types::ISO8601Date, required: false
    argument :priority, Integer, required: false

    field :task, Types::TaskType, null: true
    field :errors, [String], null: false

    def resolve(id:, **attrs)
      user = context[:current_user]
      raise GraphQL::ExecutionError, "Unauthorized" unless user

      task = Task.find_by(id: id)
      raise GraphQL::ExecutionError, "Task not found" unless task

      if attrs[:due_date]
        project = task.project
        if attrs[:due_date] > project.end_date
          return { task: nil, errors: ["Due date cannot be after project end date"] }
        end
      end

      if task.update(attrs)
        { task: task, errors: [] }
      else
        { task: nil, errors: task.errors.full_messages }
      end
    end
  end
end
