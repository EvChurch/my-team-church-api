# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Resolvers::TeamResolver do
  let!(:account) { create(:account, remote_id: 'remote_account_id') }
  let(:user) { create(:user, remote_id: 'remote_user_id') }
  let(:team) { create(:team, remote_id: 'remote_team_id') }
  let(:query) { <<~GRAPHQL }
    query($id: ID!) {
      team(id: $id) {
        account { id }
        contacts { id }
        createdAt
        definition
        id
        parent { id }
        realms { id }
        remoteId
        slug
        status
        title
        updatedAt
      }
    }
  GRAPHQL
  let(:result) do
    {
      'data' => nil,
      'errors' => [{
        'locations' => [{ 'column' => 3, 'line' => 2 }],
        'message' => 'Team not found',
        'path' => ['team']
      }]
    }
  end

  it 'returns not found error' do
    response = MyTeamChurchApiSchema.execute(
      query, variables: { id: team.id }, context: { current_account: account, current_user: user }
    )
    expect(response.to_h).to eq result
  end

  context 'when user is team member of invisible team' do
    before do
      contact = create(:contact)
      user.contacts << contact
      team.contacts << contact
    end

    it 'returns not found error' do
      response = MyTeamChurchApiSchema.execute(
        query, variables: { id: team.id }, context: { current_account: account, current_user: user }
      )
      expect(response.to_h).to eq result
    end
  end

  context 'when user is team member of visible team' do
    let(:result) do
      {
        'data' => {
          'team' => {
            'account' => { 'id' => account.id },
            'contacts' => [{ 'id' => team.contacts.first.id }],
            'createdAt' => team.created_at.iso8601,
            'definition' => team.definition,
            'id' => team.id,
            'parent' => nil,
            'realms' => [],
            'remoteId' => 'remote_team_id',
            'slug' => team.slug,
            'status' => team.status,
            'title' => team.title,
            'updatedAt' => team.updated_at.iso8601
          }
        }
      }
    end
    let(:team) { create(:team, remote_id: 'remote_team_id', visible_members: true) }

    before do
      contact = create(:contact)
      user.contacts << contact
      team.contacts << contact
    end

    it 'returns team' do
      response = MyTeamChurchApiSchema.execute(
        query, variables: { id: team.id }, context: { current_account: account, current_user: user }
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
          'path' => ['team']
        }]
      }
    end

    it 'returns authorization error' do
      response = MyTeamChurchApiSchema.execute(query, variables: { id: team.id })
      expect(response.to_h).to eq result
    end
  end
end
