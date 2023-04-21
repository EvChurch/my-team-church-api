# frozen_string_literal: true

module Mutations
  module Objective
    module Activity
      class CreateMutation < Mutations::BaseMutation
        graphql_name 'ObjectiveActivityCreateMutation'
        description 'create a activity belonging to an objective'

        argument :activity, Types::Inputs::Objective::ActivityInputType, 'activity to create', required: true,
                                                                                               as: :attributes

        field :activity, Types::Objects::Objective::ActivityType, 'created activity', null: true

        def resolve(attributes:)
          activity = ::Objective::Activity.create(attributes.to_h)
          activity.save!
          { activity: }
        end

        def authorized?(attributes:)
          objective = ::Objective.find(attributes[:objective_id])
          team_id = objective.team_id
          super && context[:current_user].present? && context[:current_user].team_ids.include?(team_id)
        end
      end
    end
  end
end
