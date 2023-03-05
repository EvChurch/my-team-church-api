# frozen_string_literal: true

module Types
  class MutationType < Types::BaseObject
    field :user_login, mutation: Mutations::UserLoginMutation
  end
end
