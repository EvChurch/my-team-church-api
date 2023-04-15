# frozen_string_literal: true

module Types
  class QueryType < Types::BaseObject
    description 'Base Query Type'

    field :contacts, description: 'retrieve contacts', resolver: Resolvers::ContactsResolver
    field :me, description: 'current user', resolver: Resolvers::MeResolver
    field :objectives, description: 'retrieve objectives', resolver: Resolvers::ObjectivesResolver
    field :team, description: 'retrieve team', resolver: Resolvers::TeamResolver
  end
end
