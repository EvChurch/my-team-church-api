# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Resolvers::Objective::ActivityResolver do
  let!(:account) { create(:account, remote_id: 'remote_account_id') }
  let(:user) { create(:user, contacts: [contact]) }
  let(:contact) { create(:contact) }
  let(:team) { create(:team, contacts: [contact], visible_members: true) }
  let(:objective) { create(:objective, team:, contact:) }
  let(:activity) { create(:objective_activity, objective:, contact:) }
  let(:query) { <<~GRAPHQL }
    query($id: ID!) {
      objectiveActivity(id: $id) {
        account { id }
        comment
        contact { id }
        createdAt
        currentValue
        id
        kind
        objective { id }
        progress
        result { id }
        updatedAt
      }
    }
  GRAPHQL
  let(:result) do
    {
      'account' => { 'id' => account.id },
      'comment' => nil,
      'contact' => { 'id' => contact.id },
      'createdAt' => activity.created_at.iso8601,
      'currentValue' => nil,
      'id' => activity.id,
      'kind' => activity.kind,
      'objective' => { 'id' => objective.id },
      'progress' => activity.progress,
      'result' => { 'id' => activity.result.id },
      'updatedAt' => objective.updated_at.iso8601
    }
  end

  it 'returns activity' do
    response = MyTeamChurchApiSchema.execute(
      query, variables: { id: activity.id }, context: { current_account: account, current_user: user }
    )
    expect(response.to_h['data']['objectiveActivity']).to eq result
  end

  context 'when activity is not connected to user' do
    let(:activity) { create(:objective_activity) }
    let(:result) do
      {
        'data' => nil,
        'errors' => [{
          'locations' => [{ 'column' => 3, 'line' => 2 }],
          'message' => 'ObjectiveActivity not found',
          'path' => ['objectiveActivity']
        }]
      }
    end

    it 'returns not found error' do
      response = MyTeamChurchApiSchema.execute(
        query, variables: { id: activity.id }, context: { current_account: account, current_user: user }
      )
      expect(response.to_h).to eq result
    end
  end

  context 'when id does not exist' do
    let(:result) do
      {
        'data' => nil,
        'errors' => [{
          'locations' => [{ 'column' => 3, 'line' => 2 }],
          'message' => 'ObjectiveActivity not found',
          'path' => ['objectiveActivity']
        }]
      }
    end

    it 'returns not found error' do
      response = MyTeamChurchApiSchema.execute(
        query, variables: { id: SecureRandom.uuid }, context: { current_account: account, current_user: user }
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
          'path' => ['objectiveActivity']
        }]
      }
    end

    it 'returns authorization error' do
      response = MyTeamChurchApiSchema.execute(query, variables: { id: team.id })
      expect(response.to_h).to eq result
    end
  end
end
