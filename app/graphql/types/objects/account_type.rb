# frozen_string_literal: true

module Types
  module Objects
    class AccountType < Types::BaseObject
      description 'account which user is associated with'
      field :created_at, GraphQL::Types::ISO8601DateTime, 'time record created', null: false
      field :id, ID, 'record unique identifier', null: false
      field :slug, String, 'friendly unique identifier', null: false
      field :title, String, 'title of record', null: false
      field :updated_at, GraphQL::Types::ISO8601DateTime, 'time record updated', null: false
    end
  end
end
