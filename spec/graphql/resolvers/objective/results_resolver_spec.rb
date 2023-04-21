# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Resolvers::Objective::ResultsResolver do
  let!(:account) { create(:account) }
  let(:user) { create(:user, contacts: [contact]) }
  let(:contact) { create(:contact) }
  let(:team) { create(:team, contacts: [contact], visible_members: true) }
  let(:objective) { create(:objective, team:, contact:) }
  let!(:objective_result) { create(:objective_result, objective:, contact:) }
  let(:query) { <<~GRAPHQL }
    query($teamId: [ID!], $objectiveId: [ID!]) {
      objectiveResults(teamId: $teamId, objectiveId: $objectiveId) {
        nodes {
          id
        }
      }
    }
  GRAPHQL
  let(:result) do
    {
      'data' => {
        'objectiveResults' => {
          'nodes' => [{
            'id' => objective_result.id
          }]
        }
      }
    }
  end

  it 'returns all objective results belonging to teams that user is member of' do
    response = MyTeamChurchApiSchema.execute(
      query, context: { current_account: account, current_user: user }
    )
    expect(response.to_h).to eq result
  end

  context 'when filtering by objective' do
    before do
      objective = create(:objective, team:, contact:)
      create(:objective_result, objective:, contact:)
    end

    it 'returns results belonging to objective' do
      response = MyTeamChurchApiSchema.execute(
        query, variables: { objectiveId: [objective.id] },
               context: { current_account: account, current_user: user }
      )
      expect(response.to_h).to eq result
    end
  end

  context 'when filtering by team' do
    before do
      team = create(:team, contacts: [contact], visible_members: true)
      objective = create(:objective, team:, contact:)
      create(:objective_result, objective:, contact:)
    end

    it 'returns results belonging to team' do
      response = MyTeamChurchApiSchema.execute(
        query, variables: { teamId: [team.id] },
               context: { current_account: account, current_user: user }
      )
      expect(response.to_h).to eq result
    end
  end

  context 'when user is team member of invisible team' do
    let(:team) { create(:team, contacts: [contact]) }
    let(:result) do
      {
        'data' => { 'objectiveResults' => { 'nodes' => [] } }
      }
    end

    it 'returns empty' do
      response = MyTeamChurchApiSchema.execute(
        query, context: { current_account: account, current_user: user }
      )
      expect(response.to_h).to eq result
    end
  end

  context 'when no current user' do
    let(:result) do
      {
        'data' => nil,
        'errors' => [{
          'locations' => [{ 'column' => 3, 'line' => 2 }],
          'message' => 'An object of type Query was hidden due to permissions',
          'path' => ['objectiveResults']
        }]
      }
    end

    it 'returns authorization error' do
      response = MyTeamChurchApiSchema.execute(
        query, context: { current_account: account }
      )
      expect(response.to_h).to eq result
    end
  end
end
