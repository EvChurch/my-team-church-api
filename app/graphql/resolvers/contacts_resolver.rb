# frozen_string_literal: true

module Resolvers
  class ContactsResolver < BaseResolver
    description 'retrieve a collection of contacts'

    type Types::Objects::ContactType.connection_type, null: false
    argument :status, Types::Enums::StatusType, 'status to filter by', required: false
    argument :team_id, ID, 'id or slug of the team to fetch contacts', required: false

    def resolve(status: nil, team_id: nil)
      collection = contacts(team_id:)
      collection = collection.where(status:) if status.present?
      collection.order(:title)
    end

    def authorized?(status: nil, team_id: nil)
      super && context[:current_user].present?
    end

    protected

    def contacts(team_id:)
      @contacts = if team_id.present?
                    context[:current_user].teams.friendly.find(team_id).contacts
                  else
                    context[:current_user].contacts
                  end
    end
  end
end
