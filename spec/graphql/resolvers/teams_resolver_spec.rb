# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Resolvers::TeamsResolver do
  let!(:account) { create(:account, remote_id: 'remote_account_id') }
  let(:user) { create(:user, remote_id: 'remote_user_id', contacts: [contact]) }
  let(:contact) { create(:contact, remote_id: 'remote_team_id') }
  let!(:team) { create(:team, remote_id: 'remote_team_id', visible_members: true, contacts: [contact]) }
  let(:query) { <<~GRAPHQL }
    query($status: Status) {
      teams(status: $status) {
        nodes {
          account { id }
          contacts { id }
          createdAt
          definition
          id
          objectives { id }
          parent { id }
          realms { id }
          remoteId
          slug
          status
          title
          updatedAt
        }
      }
    }
  GRAPHQL
  let(:result) do
    {
      'data' => {
        'teams' => {
          'nodes' => [{
            'account' => { 'id' => account.id },
            'contacts' => team.contacts.map { |contact| { 'id' => contact.id } },
            'createdAt' => team.created_at.iso8601,
            'definition' => 'team',
            'id' => team.id,
            'objectives' => [],
            'parent' => nil,
            'realms' => [],
            'remoteId' => 'remote_team_id',
            'slug' => team.slug,
            'status' => team.status,
            'title' => team.title,
            'updatedAt' => team.updated_at.iso8601
          }]
        }
      }
    }
  end

  it 'returns all teams that user is member of' do
    response = MyTeamChurchApiSchema.execute(
      query, context: { current_account: account, current_user: user }
    )
    expect(response.to_h).to eq result
  end

  context 'when status is active' do
    let(:team) do
      create(:team, remote_id: 'remote_team_id', status: 'active', visible_members: true, contacts: [contact])
    end

    before do
      create(:team, contacts: [contact], visible_members: true, status: 'draft')
      create(:team, contacts: [contact], visible_members: true, status: 'draft')
    end

    it 'returns active teams that user is a member of' do
      response = MyTeamChurchApiSchema.execute(
        query, variables: { status: 'active' },
               context: { current_account: account, current_user: user }
      )
      expect(response.to_h).to eq result
    end
  end

  context 'when status is draft' do
    let(:team) do
      create(:team, remote_id: 'remote_team_id', contacts: [contact], visible_members: true, status: 'draft')
    end

    before do
      create(:team, contacts: [contact], visible_members: true)
      create(:team, contacts: [contact], visible_members: true)
    end

    it 'returns draft teams that user is a member of' do
      response = MyTeamChurchApiSchema.execute(
        query, variables: { status: 'draft' },
               context: { current_account: account, current_user: user }
      )
      expect(response.to_h).to eq result
    end
  end

  context 'when status is archived' do
    let(:team) do
      create(:team, remote_id: 'remote_team_id', contacts: [contact], visible_members: true, status: 'archived')
    end

    before do
      create(:team, contacts: [contact], visible_members: true)
      create(:team, contacts: [contact], visible_members: true)
    end

    it 'returns archived teams that user is a member of' do
      response = MyTeamChurchApiSchema.execute(
        query, variables: { status: 'archived' },
               context: { current_account: account, current_user: user }
      )
      expect(response.to_h).to eq result
    end
  end

  context 'when user is team member of invisible team' do
    let!(:team) { create(:team, remote_id: 'remote_team_id', contacts: [contact]) }
    let(:result) do
      { 'data' => { 'teams' => { 'nodes' => [] } } }
    end

    it 'returns empty list' do
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
          'path' => ['teams']
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
