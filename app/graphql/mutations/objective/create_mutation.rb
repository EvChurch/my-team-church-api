# frozen_string_literal: true

module Mutations
  module Objective
    class CreateMutation < Mutations::BaseMutation
      graphql_name 'ObjectiveCreateMutation'
      description 'create an objective'

      argument :objective, Types::Inputs::ObjectiveInputType, 'objective to create', required: true, as: :attributes

      field :objective, Types::Objects::ObjectiveType, 'created objective', null: true

      def resolve(attributes:)
        objective = ::Objective.create(attributes.to_h)
        objective.save!
        { objective: }
      end

      def authorized?(attributes:)
        team_id = attributes[:team_id]
        super && context[:current_user].present? && context[:current_user].team_ids.include?(team_id)
      end
    end
  end
end
