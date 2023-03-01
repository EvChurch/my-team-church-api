# frozen_string_literal: true

module Types
  class QueryType < Types::BaseObject
    description 'Base Query Type'
    # Add `node(id: ID!) and `nodes(ids: [ID!]!)`
    include GraphQL::Types::Relay::HasNodeField
    include GraphQL::Types::Relay::HasNodesField
    field :organizations,
          Types::Objects::OrganizationType.connection_type,
          'organizations belonging to the current user',
          null: false
    field :realms,
          Types::Objects::RealmType.connection_type,
          'realms belonging to the current organization',
          null: false

    def realms
      Organization.first.realms
    end

    def organizations
      Organization.all
    end
  end
end
