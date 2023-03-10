# frozen_string_literal: true

module Types
  module Objects
    class TeamType < Types::BaseObject
      description 'team with members in positions'

      field :account, Types::Objects::AccountType, 'account record belongs to', null: false
      field :contacts, [Types::Objects::ContactType], 'team members', null: false
      field :created_at, GraphQL::Types::ISO8601DateTime, 'time record created', null: false
      field :definition, String, 'record sub-type', null: false
      field :id, ID, 'record unique identifier', null: false
      field :parent, Types::Objects::TeamType, 'optional parent record'
      field :realms, [Types::Objects::RealmType], 'realms the contact belongs to', null: false
      field :remote_id, String, 'unique identifier in fluro'
      field :slug, String, 'friendly unique identifier', null: false
      field :status, Types::Enums::StatusType, 'record status'
      field :title, String, 'title of record', null: false
      field :updated_at, GraphQL::Types::ISO8601DateTime, 'time record updated', null: false
    end
  end
end
