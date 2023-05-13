# frozen_string_literal: true

module Resolvers
  module Team
    class PositionsResolver < BaseResolver
      description 'retrieve a collection of positions'

      type Types::Objects::Team::PositionType.connection_type, null: false
      argument :team_id, ID, 'id or slug of team to fetch positions for'

      def resolve(team_id:)
        collection = context[:current_user].teams.friendly.find(team_id).positions
        collection.order(:title)
      end

      def authorized?(team_id:)
        super && context[:current_user].present?
      end
    end
  end
end
