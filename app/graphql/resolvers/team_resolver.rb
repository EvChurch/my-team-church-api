# frozen_string_literal: true

module Resolvers
  class TeamResolver < BaseResolver
    description 'retrieve team connected to current user'

    type Types::Objects::TeamType, null: false

    argument :id, ID, 'id or slug of the team being retrieved'

    def resolve(id:)
      context[:current_user].teams.friendly.find(id)
    end

    def authorized?(id:)
      super && context[:current_user].present?
    end
  end
end
