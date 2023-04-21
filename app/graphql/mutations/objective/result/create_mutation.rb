# frozen_string_literal: true

module Mutations
  module Objective
    module Result
      class CreateMutation < Mutations::BaseMutation
        graphql_name 'ObjectiveResultCreateMutation'
        description 'create a result'

        argument :result, Types::Inputs::Objective::ResultInputType, 'Result to create', required: true, as: :attributes

        field :result, Types::Objects::Objective::ResultType, 'created result', null: true

        def resolve(attributes:)
          result = ::Objective::Result.create(attributes.to_h)
          result.save!
          { result: }
        end

        def authorized?(attributes:)
          objective = ::Objective.find(attributes[:objective_id])
          super && context[:current_user].present? && context[:current_user].team_ids.include?(objective.team_id)
        end
      end
    end
  end
end
