# frozen_string_literal: true

module Resolvers
  class ObjectiveResolver < BaseResolver
    description 'retrieve an activity'

    type Types::Objects::Objective::ActivityType, null: false
    argument :id, ID, 'id of activity to retrieve', required: false

    def resolve(id:)
      context[:current_user].team_activities.find(id)
    end

    def authorized?(id:)
      super && context[:current_user].present?
    end
  end
end
