# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Resolvers::ContactsResolver do
  let!(:account) { create(:account, remote_id: 'remote_account_id') }
  let(:user) { create(:user, remote_id: 'remote_user_id', contacts: [contact]) }
  let(:team) { create(:team, remote_id: 'remote_team_id') }
  let(:contact) { create(:contact, remote_id: 'remote_contact_id') }
  let(:query) { <<~GRAPHQL }
    query($teamId: ID, $status: Status) {
      contacts(teamId: $teamId, status: $status) {
        nodes {
          account { id }
          avatar
          createdAt
          definition
          emails
          firstName
          id
          lastName
          objectives { id }
          phoneNumbers
          realms { id }
          remoteId
          slug
          status
          teams { id }
          title
          updatedAt
        }
      }
    }
  GRAPHQL
  let(:result) do
    {
      'data' => {
        'contacts' => {
          'nodes' => [{
            'account' => { 'id' => account.id },
            'avatar' => nil,
            'createdAt' => contact.created_at.iso8601,
            'definition' => 'contact',
            'emails' => contact.emails,
            'firstName' => contact.first_name,
            'id' => contact.id,
            'lastName' => contact.last_name,
            'objectives' => [],
            'phoneNumbers' => contact.phone_numbers,
            'realms' => [],
            'remoteId' => 'remote_contact_id',
            'slug' => contact.slug,
            'status' => contact.status,
            'teams' => [],
            'title' => contact.title,
            'updatedAt' => contact.updated_at.iso8601
          }]
        }
      }
    }
  end

  it 'returns contacts connected with user' do
    response = MyTeamChurchApiSchema.execute(
      query, context: { current_account: account, current_user: user }
    )
    expect(response.to_h).to eq result
  end

  context 'when status is draft' do
    let(:contact) { create(:contact, remote_id: 'remote_contact_id', status: 'draft') }
    let(:user) { create(:user, remote_id: 'remote_user_id', contacts: [contact, create(:contact)]) }

    it 'returns draft contacts connected with user' do
      response = MyTeamChurchApiSchema.execute(
        query, variables: { status: 'draft' },
               context: { current_account: account, current_user: user }
      )
      expect(response.to_h).to eq result
    end
  end

  context 'when status is archived' do
    let(:contact) { create(:contact, remote_id: 'remote_contact_id', status: 'archived') }
    let(:user) { create(:user, remote_id: 'remote_user_id', contacts: [contact, create(:contact)]) }

    it 'returns draft contacts connected with user' do
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
          'message' => 'ContactConnection not found',
          'path' => ['contacts']
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

    before do
      team.contacts = user.contacts
      result['data']['contacts']['nodes'][0]['teams'] = [{ 'id' => team.id }]
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
          'path' => ['contacts']
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
