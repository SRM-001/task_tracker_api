module Mutations
  class CreateOrUpdateProject < BaseMutation
    argument :id, ID, required: false
    argument :name, String, required: true
    argument :desc, String, required: true
    argument :start_date, GraphQL::Types::ISO8601Date, required: true
    argument :end_date, GraphQL::Types::ISO8601Date, required: true

    field :project, Types::ProjectType, null: true
    field :errors, [String], null: false

    def resolve(id: nil, name:, desc:, start_date:, end_date:)
      user = context[:current_user]
      return { project: nil, errors: ["Unauthorized"] } unless user&.role == "admin"

      project = id ? Project.find_by(id: id) : Project.new(user: user)

      return { project: nil, errors: ["Project not found"] } if id && project.nil?

      if project.update(name: name, desc: desc, start_date: start_date, end_date: end_date)
        { project: project, errors: [] }
      else
        { project: nil, errors: project.errors.full_messages }
      end
    end
  end
end
