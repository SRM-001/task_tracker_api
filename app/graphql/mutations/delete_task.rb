module Mutations
  class DeleteTask < BaseMutation
    argument :id, ID, required: true
    field :message, String, null: false

    def resolve(id:)
      user = context[:current_user]
      raise GraphQL::ExecutionError, "Unauthorized" unless user&.admin?

      task = Task.find_by(id: id)
      raise GraphQL::ExecutionError, "Task not found" unless task

      task.destroy
      { message: "Task deleted successfully" }
    end
  end
end
