# frozen_string_literal: true

module Types
  class QueryType < Types::BaseObject
    description 'Base Query Type'
    # Add `node(id: ID!) and `nodes(ids: [ID!]!)`
    include GraphQL::Types::Relay::HasNodeField
    include GraphQL::Types::Relay::HasNodesField
    field :account,
          Types::Objects::AccountType,
          'accounts belonging to the current user',
          null: false
    field :realms,
          Types::Objects::RealmType.connection_type,
          'realms belonging to the current account',
          null: false

    def realms
      Realm.all
    end

    def account
      context[:current_account]
    end
  end
end
