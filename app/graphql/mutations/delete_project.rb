module Mutations
  class DeleteProject < BaseMutation
    argument :id, ID, required: true
    field :message, String, null: false

    def resolve(id:)
      user = context[:current_user]
      raise GraphQL::ExecutionError, "Unauthorized" unless user&.admin?

      project = Project.find_by(id: id)
      raise GraphQL::ExecutionError, "Project not found" unless project

      project.destroy
      { message: "Project deleted successfully" }
    end
  end
end
