module Types
  class TaskType < Types::BaseObject
    field :id, ID, null: false
    field :title, String, null: false
    field :desc, String, null: true
    field :status, String, null: false
    field :due_date, GraphQL::Types::ISO8601Date, null: false
    field :priority, Integer, null: true
  end
end
