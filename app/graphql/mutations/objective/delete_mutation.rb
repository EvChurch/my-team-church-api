# frozen_string_literal: true

module Mutations
  module Objective
    class DeleteMutation < Mutations::BaseMutation
      graphql_name 'ObjectiveDeleteMutation'
      description 'delete an objective'

      argument :id, ID, 'objective id to delete', required: true
      field :id, ID, 'id of objective after delete', null: true

      def resolve(id:)
        objective = ::Objective.find(id)
        objective.destroy!
        { id: }
      end

      def authorized?(id:)
        objective = ::Objective.find_by(id:)
        team_id = objective&.team_id
        super && team_id.present? && context[:current_user].present? &&
          context[:current_user].team_ids.include?(team_id)
      end
    end
  end
end
