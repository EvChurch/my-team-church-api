# frozen_string_literal: true

module Resolvers
  module Objective
    class ResultResolver < BaseResolver
      description 'retrieve a result'

      type Types::Objects::Objective::ResultType, null: false
      argument :id, ID, 'id of result to retrieve', required: false

      def resolve(id:)
        context[:current_user].team_results.find(id)
      end

      def authorized?(id:)
        super && context[:current_user].present?
      end
    end
  end
end
