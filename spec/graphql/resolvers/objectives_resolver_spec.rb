# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Resolvers::ObjectivesResolver do
  let!(:account) { create(:account, remote_id: 'remote_account_id') }
  let(:user) { create(:user, remote_id: 'remote_user_id', contacts: [contact]) }
  let(:contact) { create(:contact) }
  let(:team) { create(:team, remote_id: 'remote_team_id') }
  let!(:objective) { create(:objective, contact:) }
  let(:query) { <<~GRAPHQL }
    query($teamId: ID, $status: Status) {
      objectives(teamId: $teamId, status: $status) {
        nodes {
          account { id }
          contact { id }
          createdAt
          id
          status
          team { id }
          title
          updatedAt
        }
      }
    }
  GRAPHQL
  let(:result) do
    {
      'data' => {
        'objectives' => {
          'nodes' => [{
            'account' => { 'id' => account.id },
            'contact' => { 'id' => contact.id },
            'createdAt' => objective.created_at.iso8601,
            'id' => objective.id,
            'status' => objective.status,
            'team' => { 'id' => objective.team_id },
            'title' => objective.title,
            'updatedAt' => objective.updated_at.iso8601
          }]
        }
      }
    }
  end

  it 'returns objectives connected with user' do
    response = MyTeamChurchApiSchema.execute(
      query, context: { current_account: account, current_user: user }
    )
    expect(response.to_h).to eq result
  end

  context 'when status is draft' do
    let(:objective) { create(:objective, contact:, status: 'draft') }

    before { create(:objective, contact:) }

    it 'returns draft objectives connected with user' do
      response = MyTeamChurchApiSchema.execute(
        query, variables: { status: 'draft' },
               context: { current_account: account, current_user: user }
      )
      expect(response.to_h).to eq result
    end
  end

  context 'when status is archived' do
    let(:objective) { create(:objective, contact:, status: 'archived') }

    before { create(:objective, contact:) }

    it 'returns archived objectives connected with user' do
      response = MyTeamChurchApiSchema.execute(
        query, variables: { status: 'archived' },
               context: { current_account: account, current_user: user }
      )
      expect(response.to_h).to eq result
    end
  end

  context 'when user is team member of invisible team' do
    let(:result) do
      {
        'data' => nil,
        'errors' => [{
          'locations' => [{ 'column' => 3, 'line' => 2 }],
          'message' => 'ObjectiveConnection not found',
          'path' => ['objectives']
        }]
      }
    end

    before { team.contacts = user.contacts }

    it 'returns not found error' do
      response = MyTeamChurchApiSchema.execute(
        query, variables: { teamId: team.id },
               context: { current_account: account, current_user: user }
      )
      expect(response.to_h).to eq result
    end
  end

  context 'when user is team member of visible team' do
    let(:team) { create(:team, remote_id: 'remote_team_id', visible_members: true) }
    let(:objective) { create(:objective, contact:, team:) }

    before do
      team.contacts = user.contacts
      result['data']['objectives']['nodes'][0]['team'] = { 'id' => team.id }
    end

    it 'returns members of team' do
      response = MyTeamChurchApiSchema.execute(
        query, variables: { teamId: team.id },
               context: { current_account: account, current_user: user }
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
          'path' => ['objectives']
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
