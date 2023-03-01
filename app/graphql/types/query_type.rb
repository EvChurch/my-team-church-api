# frozen_string_literal: true

module Types
  class QueryType < Types::BaseObject
    description 'Base Query Type'
    # Add `node(id: ID!) and `nodes(ids: [ID!]!)`
    include GraphQL::Types::Relay::HasNodeField
    include GraphQL::Types::Relay::HasNodesField
    field :accounts,
          Types::Objects::AccountType.connection_type,
          'accounts belonging to the current user',
          null: false
    field :realms,
          Types::Objects::RealmType.connection_type,
          'realms belonging to the current account',
          null: false

    def realms
      Account.first.realms
    end

    def accounts
      Account.all
    end
  end
end
