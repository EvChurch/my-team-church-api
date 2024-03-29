# frozen_string_literal: true

module Types
  class MutationType < Types::BaseObject
    description 'Base Mutation Type'

    field :early_access_create, description: 'create an early access request',
                                mutation: Mutations::EarlyAccess::CreateMutation
    field :objective_activity_create, description: 'create an activity belonging to a objective',
                                      mutation: Mutations::Objective::Activity::CreateMutation
    field :objective_create, description: 'create an objective', mutation: Mutations::Objective::CreateMutation
    field :objective_delete, description: 'delete objective',
                             mutation: Mutations::Objective::DeleteMutation
    field :objective_result_create, description: 'create a result belonging to an objective',
                                    mutation: Mutations::Objective::Result::CreateMutation
    field :objective_result_delete, description: 'delete result',
                                    mutation: Mutations::Objective::Result::DeleteMutation
    field :user_login, description: 'authenticate a user', mutation: Mutations::User::LoginMutation
  end
end
