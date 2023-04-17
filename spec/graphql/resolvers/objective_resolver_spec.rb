# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Resolvers::ObjectiveResolver do
  let!(:account) { create(:account, remote_id: 'remote_account_id') }
  let(:user) { create(:user, contacts: [contact]) }
  let(:contact) { create(:contact) }
  let(:team) { create(:team, contacts: [contact], visible_members: true) }
  let(:objective) { create(:objective, team:, contact:) }
  let(:query) { <<~GRAPHQL }
    query($id: ID!) {
      objective(id: $id) {
        account { id }
        contact { id }
        createdAt
        description
        dueAt
        id
        status
        team { id }
        title
        updatedAt
      }
    }
  GRAPHQL
  let(:result) do
    {
      'data' => {
        'objective' => {
          'account' => { 'id' => account.id },
          'contact' => { 'id' => contact.id },
          'createdAt' => objective.created_at.iso8601,
          'description' => nil,
          'dueAt' => objective.due_at.iso8601,
          'id' => objective.id,
          'status' => objective.status,
          'team' => { 'id' => objective.team_id },
          'title' => objective.title,
          'updatedAt' => objective.updated_at.iso8601
        }
      }
    }
  end

  it 'returns objective' do
    response = MyTeamChurchApiSchema.execute(
      query, variables: { id: objective.id }, context: { current_account: account, current_user: user }
    )
    expect(response.to_h).to eq result
  end

  context 'when objective is not connected to user' do
    let(:objective) { create(:objective) }
    let(:result) do
      {
        'data' => nil,
        'errors' => [{
          'locations' => [{ 'column' => 3, 'line' => 2 }],
          'message' => 'Objective not found',
          'path' => ['objective']
        }]
      }
    end

    it 'returns not found error' do
      response = MyTeamChurchApiSchema.execute(
        query, variables: { id: objective.id }, context: { current_account: account, current_user: user }
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
          'message' => 'Objective not found',
          'path' => ['objective']
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
          'path' => ['objective']
        }]
      }
    end

    it 'returns authorization error' do
      response = MyTeamChurchApiSchema.execute(query, variables: { id: team.id })
      expect(response.to_h).to eq result
    end
  end
end
