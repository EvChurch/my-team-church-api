# frozen_string_literal: true

module Mutations
  module Objective
    module Result
      class DeleteMutation < Mutations::BaseMutation
        graphql_name 'ObjectiveResultDeleteMutation'
        description 'delete a result'

        argument :id, ID, 'result id to delete', required: true
        field :id, ID, 'id of result after delete', null: true

        def resolve(id:)
          result = ::Objective::Result.find(id)
          result.destroy!
          { id: }
        end

        def authorized?(id:)
          result = ::Objective::Result.find_by(id:)
          team_id = result&.objective&.team_id
          super && team_id.present? && context[:current_user].present? &&
            context[:current_user].team_ids.include?(team_id)
        end
      end
    end
  end
end
