# frozen_string_literal: true

module Types
  class MutationType < Types::BaseObject
    description 'Base Mutation Type'

    field :objective_create, description: 'create a objective', mutation: Mutations::ObjectiveCreateMutation
    field :user_login, description: 'authenticate a user', mutation: Mutations::UserLoginMutation
  end
end
