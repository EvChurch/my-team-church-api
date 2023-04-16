# frozen_string_literal: true

module Mutations
  class ObjectiveCreateMutation < Mutations::BaseMutation
    description 'create an objective'

    argument :objective, Types::Inputs::ObjectiveInputType, 'Objective to create', required: true, as: :attributes

    field :errors, [String], 'array of error messages', null: false
    field :objective, Types::Objects::ObjectiveType, 'created objective', null: true

    def resolve(attributes:)
      objective = Objective.create(attributes.to_h)

      return { objective:, errors: [] } if objective.save

      {
        objective: nil,
        errors: objective.errors.full_messages
      }
    end
  end
end
