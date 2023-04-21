# frozen_string_literal: true

module Types
  class MutationType < Types::BaseObject
    description 'Base Mutation Type'

    field :objective_activity_create, description: 'create an activity belonging to a objective',
                                      mutation: Mutations::Objective::Activity::CreateMutation
    field :objective_create, description: 'create an objective', mutation: Mutations::Objective::CreateMutation
    field :objective_result_create, description: 'create a result belonging to an objective',
                                    mutation: Mutations::Objective::Result::CreateMutation
    field :user_login, description: 'authenticate a user', mutation: Mutations::User::LoginMutation
  end
end
