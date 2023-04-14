# frozen_string_literal: true

module Resolvers
  class MeResolver < BaseResolver
    description 'retrieve current user (requires authorization header to be set)'

    type Types::Objects::UserType, null: false

    def resolve
      context[:current_user]
    end

    def authorized?
      super && context[:current_user].present?
    end
  end
end
