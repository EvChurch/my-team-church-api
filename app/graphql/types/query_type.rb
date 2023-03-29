# frozen_string_literal: true

module Types
  class QueryType < Types::BaseObject
    description 'Base Query Type'

    field :me, description: 'current user', resolver: Resolvers::MeResolver
    field :team, description: 'retrieve team', resolver: Resolvers::TeamResolver
  end
end
