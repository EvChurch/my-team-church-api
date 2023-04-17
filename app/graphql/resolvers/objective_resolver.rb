# frozen_string_literal: true

module Resolvers
  class ObjectiveResolver < BaseResolver
    description 'retrieve an objective'

    type Types::Objects::ObjectiveType, null: false
    argument :id, ID, 'id of objective to retrieve', required: false

    def resolve(id:)
      context[:current_user].team_objectives.find(id)
    end

    def authorized?(id:)
      super && context[:current_user].present?
    end
  end
end
