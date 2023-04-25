# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Resolvers::Objective::ResultResolver do
  let!(:account) { create(:account) }
  let(:user) { create(:user, contacts: [contact]) }
  let(:contact) { create(:contact) }
  let(:team) { create(:team, contacts: [contact], visible_members: true) }
  let(:objective) { create(:objective, team:, contact:) }
  let(:objective_result) { create(:objective_result, objective:, contact:) }
  let(:query) { <<~GRAPHQL }
    query($id: ID!) {
      objectiveResult(id: $id) {
        account { id }
        activities { id }
        contact { id }
        createdAt
        currentValue
        description
        dueAt
        id
        kind
        measurement
        objective { id }
        percentage
        progress
        startAt
        startValue
        status
        targetValue
        title
        updatedAt
      }
    }
  GRAPHQL
  let(:result) do
    {
      'account' => { 'id' => account.id },
      'activities' => [],
      'contact' => { 'id' => contact.id },
      'createdAt' => objective_result.created_at.iso8601,
      'currentValue' => nil,
      'description' => nil,
      'dueAt' => nil,
      'id' => objective_result.id,
      'kind' => objective_result.kind,
      'measurement' => objective_result.measurement,
      'objective' => { 'id' => objective.id },
      'percentage' => objective_result.percentage,
      'progress' => objective_result.progress,
      'startAt' => nil,
      'startValue' => objective_result.start_value,
      'status' => objective_result.status,
      'targetValue' => objective_result.target_value,
      'title' => objective_result.title,
      'updatedAt' => objective_result.updated_at.iso8601
    }
  end

  it 'returns result' do
    response = MyTeamChurchApiSchema.execute(
      query, variables: { id: objective_result.id }, context: { current_account: account, current_user: user }
    )
    expect(response.to_h['data']['objectiveResult']).to eq result
  end

  context 'when result is not connected to user' do
    let(:objective_result) { create(:objective_result) }
    let(:result) do
      {
        'data' => nil,
        'errors' => [{
          'locations' => [{ 'column' => 3, 'line' => 2 }],
          'message' => 'ObjectiveResult not found',
          'path' => ['objectiveResult']
        }]
      }
    end

    it 'returns not found error' do
      response = MyTeamChurchApiSchema.execute(
        query, variables: { id: objective_result.id }, context: { current_account: account, current_user: user }
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
          'message' => 'ObjectiveResult not found',
          'path' => ['objectiveResult']
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
          'path' => ['objectiveResult']
        }]
      }
    end

    it 'returns authorization error' do
      response = MyTeamChurchApiSchema.execute(query, variables: { id: objective_result.id })
      expect(response.to_h).to eq result
    end
  end
end
