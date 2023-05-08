# frozen_string_literal: true

module Types
  module Objects
    class EarlyAccessType < Types::BaseObject
      description 'person requesting early access'
      field :created_at, GraphQL::Types::ISO8601DateTime, 'time record created', null: false
      field :email_address, String, 'email address of interested person', null: false
      field :first_name, String, 'first name of interested person', null: false
      field :id, ID, 'record unique identifier', null: false
      field :updated_at, GraphQL::Types::ISO8601DateTime, 'time record updated', null: false
    end
  end
end
