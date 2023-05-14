# frozen_string_literal: true

module Types
  module Objects
    module Team
      class PositionType < Types::BaseObject
        description 'position on a team'
        field :assignments_count, Int, 'number of assignments', null: false
        field :contacts, Types::Objects::ContactType.connection_type, 'contacts in this position', null: false
        field :created_at, GraphQL::Types::ISO8601DateTime, 'time record created', null: false
        field :exclude, Boolean, 'contacts in this position will not be considered members of the group', null: false
        field :id, ID, 'record unique identifier', null: false
        field :remote_id, String, 'unique identifier in fluro'
        field :reporter, Boolean, 'send reporting requests to contacts in this position', null: false
        field :required_assignments_count, Int, 'number of required assignments', null: false
        field :slug, String, 'friendly unique identifier', null: false
        field :title, String, 'title of record', null: false
        field :updated_at, GraphQL::Types::ISO8601DateTime, 'time record updated', null: false

        def contacts
          object.contacts.order(:title)
        end
      end
    end
  end
end
