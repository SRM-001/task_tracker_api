# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    return unless user.present?

    if user.admin?
      can :manage, Project
      can :manage, Task
    elsif user.manager?
      can :read, Project, user_id: user.id
      can :create, Task
      can :read, Task, project: { user_id: user.id }
      can :update, Task, project: { user_id: user.id }
      can :destroy, Task, project: { user_id: user.id }
    end
  end
end
