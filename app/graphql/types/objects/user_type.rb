# frozen_string_literal: true

module Types
  module Objects
    class UserType < Types::BaseObject
      description 'a user belonging to the current account on fluro'
      field :account, Types::Objects::AccountType, 'account record belongs to', null: false
      field :contacts, [Types::Objects::ContactType], 'contacts that user is connected with', null: false
      field :created_at, GraphQL::Types::ISO8601DateTime, 'time record created', null: false
      field :email, String, 'user email address'
      field :first_name, String, 'user first name'
      field :id, ID, 'record unique identifier', null: false
      field :last_name, String, 'user last name'
      field :phone_number, String, 'user phone number'
      field :remote_id, String, 'unique identifier in fluro'
      field :slug, String, 'friendly unique identifier', null: false
      field :title, String, 'title of record', null: false
      field :updated_at, GraphQL::Types::ISO8601DateTime, 'time record updated', null: false
    end
  end
end
