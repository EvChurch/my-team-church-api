# frozen_string_literal: true

module Types
  class QueryType < Types::BaseObject
    description 'Base Query Type'

    field :contacts, description: 'retrieve contacts', resolver: Resolvers::ContactsResolver
    field :me, description: 'current user', resolver: Resolvers::MeResolver
    field :objective, description: 'retrieve objective', resolver: Resolvers::ObjectiveResolver
    field :objectives, description: 'retrieve objectives', resolver: Resolvers::ObjectivesResolver
    field :team, description: 'retrieve team', resolver: Resolvers::TeamResolver
    field :teams, description: 'retrieve teams', resolver: Resolvers::TeamsResolver
  end
end
