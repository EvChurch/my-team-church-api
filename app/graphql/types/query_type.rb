# frozen_string_literal: true

module Types
  class QueryType < Types::BaseObject
    description 'Base Query Type'

    field :contacts, description: 'retrieve contacts', resolver: Resolvers::ContactsResolver
    field :me, description: 'current user', resolver: Resolvers::MeResolver
    field :objective, description: 'retrieve objective', resolver: Resolvers::ObjectiveResolver
    field :objective_activities, description: 'retrieve activities', resolver: Resolvers::Objective::ActivitiesResolver
    field :objective_activity, description: 'retrieve activity', resolver: Resolvers::Objective::ActivityResolver
    field :objective_result, description: 'retrieve result', resolver: Resolvers::Objective::ResultResolver
    field :objective_results, description: 'retrieve results', resolver: Resolvers::Objective::ResultsResolver
    field :objectives, description: 'retrieve objectives', resolver: Resolvers::ObjectivesResolver
    field :team, description: 'retrieve team', resolver: Resolvers::TeamResolver
    field :team_position, description: 'retrieve position for a team', resolver: Resolvers::Team::PositionResolver
    field :team_positions, description: 'retrieve positions for a team', resolver: Resolvers::Team::PositionsResolver
    field :teams, description: 'retrieve teams', resolver: Resolvers::TeamsResolver
  end
end
