# frozen_string_literal: true

module Types
  module Objects
    class ObjectiveType < Types::BaseObject
      description 'objective for a team'
      field :account, Types::Objects::AccountType, 'account record belongs to', null: false
      field :contact, Types::Objects::ContactType, 'contact objective belongs to', null: false
      field :created_at, GraphQL::Types::ISO8601DateTime, 'time record created', null: false
      field :description, String, 'description of objective', null: true
      field :due_at, GraphQL::Types::ISO8601Date, 'date objective due', null: false
      field :id, ID, 'record unique identifier', null: false
      field :status, Types::Enums::StatusType, 'record status'
      field :team, Types::Objects::TeamType, 'team objective belongs to', null: false
      field :title, String, 'title of record', null: false
      field :updated_at, GraphQL::Types::ISO8601DateTime, 'time record updated', null: false
    end
  end
end
