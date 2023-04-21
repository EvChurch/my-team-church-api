# frozen_string_literal: true

module Resolvers
  module Objective
    class ActivityResolver < BaseResolver
      description 'retrieve an activity'

      type Types::Objects::Objective::ActivityType, null: false
      argument :id, ID, 'id of activity to retrieve', required: true

      def resolve(id:)
        context[:current_user].team_activities.find(id)
      end

      def authorized?(id:)
        super && context[:current_user].present?
      end
    end
  end
end
