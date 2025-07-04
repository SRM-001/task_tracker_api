module Mutations
  class UpdateTaskStatus < BaseMutation
    argument :id, ID, required: true
    argument :status, String, required: true

    field :task, Types::TaskType, null: true
    field :errors, [String], null: false

    def resolve(id:, status:)
      task = Task.find_by(id: id)
      return { task: nil, errors: ["Task not found"] } unless task

      if context[:current_user].nil?
        return { task: nil, errors: ["Unauthorized"] }
      end

      if task.update(status: status)
        { task: task, errors: [] }
      else
        { task: nil, errors: task.errors.full_messages }
      end
    end
  end
end
