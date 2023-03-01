# frozen_string_literal: true

module Types
  module Objects
    class RealmType < Types::BaseObject
      description 'realm which controls permissions to associated objects'

      field :account, Types::Objects::AccountType, 'account record belongs to', null: false
      field :bg_color, String, 'realm background color'
      field :color, String, 'realm primary color'
      field :created_at, GraphQL::Types::ISO8601DateTime, 'time record created', null: false
      field :definition, String, 'record sub-type', null: false
      field :id, ID, 'record unique identifier', null: false
      field :parent, Types::Objects::RealmType, 'optional parent record'
      field :slug, String, 'friendly unique identifier', null: false
      field :status, Types::Enums::StatusType, 'record status'
      field :teams, Types::Objects::TeamType.connection_type, 'teams related to realm', null: false
      field :title, String, 'title of record', null: false
      field :updated_at, GraphQL::Types::ISO8601DateTime, 'time record updated', null: false
    end
  end
end
