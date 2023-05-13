# frozen_string_literal: true

module Resolvers
  module Team
    class PositionResolver < BaseResolver
      description 'retrieve a position'

      type Types::Objects::Team::PositionType, null: false

      argument :id, ID, 'id or slug of the position being retrieved'
      argument :team_id, ID, 'id or slug of team to fetch position for'

      def resolve(team_id:, id:)
        context[:current_user].teams.friendly.find(team_id).positions.friendly.find(id)
      end

      def authorized?(team_id:, id:)
        super && context[:current_user].present? 
      end
    end
  end
end
