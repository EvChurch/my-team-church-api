# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Resolvers::Team::PositionsResolver do
  let!(:account) { create(:account) }
  let(:user) { create(:user, contacts: [contact]) }
  let(:contact) { create(:contact) }
  let(:team) { create(:team, contacts: [contact], visible_members: true) }
  let!(:position1) { create(:team_position, team:, title: 'b') }
  let!(:position2) { create(:team_position, team:, title: 'a') }
  let(:query) { <<~GRAPHQL }
    query($teamId: ID!) {
      teamPositions(teamId: $teamId) {
        nodes {
          id
        }
      }
    }
  GRAPHQL
  let(:result) do
    {
      'data' => {
        'teamPositions' => {
          'nodes' => [{
            'id' => position2.id
          }, {
            'id' => position1.id
          }]
        }
      }
    }
  end

  it 'returns positions of selected team' do
    response = MyTeamChurchApiSchema.execute(
      query, context: { current_account: account, current_user: user },
             variables: { teamId: team.id }
    )
    expect(response.to_h).to eq result
  end

  context 'when team id is slug' do
    it 'returns positions of selected team' do
      response = MyTeamChurchApiSchema.execute(
        query, context: { current_account: account, current_user: user },
               variables: { teamId: team.slug }
      )
      expect(response.to_h).to eq result
    end
  end

  context 'when user is team member of invisible team' do
    let(:team) { create(:team, contacts: [contact]) }
    let(:result) do
      {
        'data' => nil,
        'errors' => [{
          'locations' => [{ 'column' => 3, 'line' => 2 }],
          'message' => 'PositionConnection not found',
          'path' => ['teamPositions']
        }]
      }
    end

    it 'returns not found' do
      response = MyTeamChurchApiSchema.execute(
        query, context: { current_account: account, current_user: user },
               variables: { teamId: team.id }
      )
      expect(response.to_h).to eq result
    end
  end

  context 'when team id is unknown' do
    let(:result) do
      {
        'data' => nil,
        'errors' => [{
          'locations' => [{ 'column' => 3, 'line' => 2 }],
          'message' => 'PositionConnection not found',
          'path' => ['teamPositions']
        }]
      }
    end

    it 'returns not found' do
      response = MyTeamChurchApiSchema.execute(
        query, context: { current_account: account, current_user: user },
               variables: { teamId: SecureRandom.uuid }
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
          'path' => ['teamPositions']
        }]
      }
    end

    it 'returns authorization error' do
      response = MyTeamChurchApiSchema.execute(
        query, context: { current_account: account },
               variables: { teamId: team.id }
      )
      expect(response.to_h).to eq result
    end
  end
end
