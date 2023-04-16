# frozen_string_literal: true

module Resolvers
  class TeamsResolver < BaseResolver
    description 'retrieve a collection of teams connected with user'

    type Types::Objects::TeamType.connection_type, null: false
    argument :status, Types::Enums::StatusType, 'status to filter by', required: false

    def resolve(status: nil)
      collection = context[:current_user].teams
      collection = collection.where(status:) if status.present?
      collection.order(:title)
    end

    def authorized?(status: nil, team_id: nil)
      super && context[:current_user].present?
    end
  end
end
