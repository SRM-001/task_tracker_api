# frozen_string_literal: true

module Types
  class MutationType < Types::BaseObject
    field :create_or_update_project, mutation: Mutations::CreateOrUpdateProject
    field :update_task_status, mutation: Mutations::UpdateTaskStatus

    field :create_task, mutation: Mutations::CreateTask
    field :delete_project, mutation: Mutations::DeleteProject
    field :delete_task, mutation: Mutations::DeleteTask
    field :update_task, mutation: Mutations::UpdateTask
  end
end
