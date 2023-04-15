# frozen_string_literal: true

module Resolvers
  class ObjectivesResolver < BaseResolver
    description 'retrieve a collection of objectives'

    type Types::Objects::ObjectiveType.connection_type, null: false
    argument :status, Types::Enums::StatusType, 'status to filter by', required: false
    argument :team_id, ID, 'id or slug of the team to fetch objectives', required: false

    def resolve(status: nil, team_id: nil)
      collection = objectives(team_id:)
      collection = collection.where(status:) if status.present?
      collection
    end

    def authorized?(status: nil, team_id: nil)
      super && context[:current_user].present?
    end

    protected

    def objectives(team_id:)
      @objectives = if team_id.present?
                      context[:current_user].teams.friendly.find(team_id).objectives
                    else
                      context[:current_user].objectives
                    end
    end
  end
end
