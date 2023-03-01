# frozen_string_literal: true

module Types
  module Objects
    class ContactType < Types::BaseObject
      description 'contact in a team or position'
      field :account, Types::Objects::AccountType, 'account record belongs to', null: false
      field :created_at, GraphQL::Types::ISO8601DateTime, 'time record created', null: false
      field :definition, String, 'record sub-type', null: false
      field :emails, [String], "contact's email addresses", null: false
      field :first_name, String, 'contact first name'
      field :id, ID, 'record unique identifier', null: false
      field :last_name, String, 'contact last name'
      field :phone_numbers, [String], "contact's phone numbers", null: false
      field :realms, [Types::Objects::RealmType], 'realms the contact belongs to', null: false
      field :remote_id, String, 'unique identifier in fluro'
      field :slug, String, 'friendly unique identifier', null: false
      field :status, Types::Enums::StatusType, 'record status'
      field :teams, [Types::Objects::TeamType], 'teams the contact belongs to', null: false
      field :title, String, 'title of record', null: false
      field :updated_at, GraphQL::Types::ISO8601DateTime, 'time record updated', null: false
    end
  end
end
