# frozen_string_literal: true

module Resolvers
  module Objective
    class ActivitiesResolver < BaseResolver
      description 'retrieve a collection of activities'

      type Types::Objects::Objective::ActivityType.connection_type, null: false
      argument :objective_id, ID, 'id of the objective to filter activities', required: false
      argument :result_id, ID, 'id of the result to filter activities', required: false
      argument :team_id, ID, 'id of the team to filter activities', required: false

      def resolve(objective_id:, result_id:, team_id:)
        collection = context[:current_user].team_activities
        collection = collection.where(objective_id:) if objective_id.present?
        collection = collection.where(team_id:) if team_id.present?
        collection = collection.where(result_id:) if result_id.present?
        collection
      end

      def authorized?(objective_id:, result_id:, team_id:)
        super && context[:current_user].present?
      end
    end
  end
end
