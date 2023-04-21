# frozen_string_literal: true

module Resolvers
  module Objective
    class ResultsResolver < BaseResolver
      description 'retrieve a collection of results'

      type Types::Objects::Objective::ResultType.connection_type, null: false
      argument :objective_id, [ID], 'id of the objective to filter results', required: false
      argument :team_id, [ID], 'id of the team to filter results', required: false

      def resolve(objective_id: nil, team_id: nil)
        collection = context[:current_user].team_results
        collection = collection.where(objective_id:) if objective_id.present?
        collection = collection.where(teams: { id: team_id }) if team_id.present?
        collection
      end

      def authorized?(objective_id: nil, team_id: nil)
        super && context[:current_user].present?
      end
    end
  end
end
