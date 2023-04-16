# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Mutations::ObjectiveCreateMutation do
  let(:account) { create(:account, remote_id: 'remote_account_id') }
  let(:user) { create(:user, remote_id: 'remote_user_id', contacts: [contact]) }
  let!(:team) { create(:team, remote_id: 'remote_user_id', contacts: [contact], visible_members: true) }
  let(:contact) { create(:contact, remote_id: 'remote_user_id') }
  let(:query) { <<~GRAPHQL }
    mutation($input: ObjectiveCreateMutationInput!) {
      objectiveCreate(input: $input) {
        objective {
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
    }
  GRAPHQL
  let(:input) do
    {
      objective: {
        title: 'title',
        description: 'description',
        dueAt: '2019-01-01',
        status: 'draft',
        teamId: team.id,
        contactId: contact.id
      }
    }
  end
  let(:result) do
    objective = Objective.find_by(title: 'title')
    {
      'data' => {
        'objectiveCreate' => {
          'objective' => {
            'account' => { 'id' => account.id },
            'contact' => { 'id' => contact.id },
            'createdAt' => objective.created_at.iso8601,
            'description' => 'description',
            'dueAt' => '2019-01-01',
            'id' => objective.id,
            'status' => 'draft',
            'team' => { 'id' => team.id },
            'title' => 'title',
            'updatedAt' => objective.updated_at.iso8601
          }
        }
      }
    }
  end

  it 'returns an objective' do
    response = MyTeamChurchApiSchema.execute(
      query, variables: { input: },
             context: { current_user: user, current_account: account }
    )
    expect(response.to_h).to eq result
  end

  context 'when contact is not a member of team' do
    let(:result) do
      {
        'data' => { 'objectiveCreate' => nil },
        'errors' => [{
          'locations' => [{ 'column' => 3, 'line' => 2 }],
          'message' => 'Validation failed: Contact contact must be member of team.',
          'path' => ['objectiveCreate']
        }]
      }
    end

    it 'returns validation error' do
      input[:objective][:contactId] = create(:contact).id
      response = MyTeamChurchApiSchema.execute(
        query, variables: { input: }, context: { current_user: user, current_account: account }
      )
      expect(response.to_h).to eq result
    end
  end

  context 'when user is not member of team' do
    let(:team) { create(:team, remote_id: 'remote_user_id', visible_members: true) }
    let(:result) do
      {
        'data' => { 'objectiveCreate' => nil },
        'errors' => [{
          'locations' => [{ 'column' => 3, 'line' => 2 }],
          'message' => 'An object of type Mutation was hidden due to permissions',
          'path' => ['objectiveCreate']
        }]
      }
    end

    it 'returns authorization error' do
      response = MyTeamChurchApiSchema.execute(
        query, variables: { input: },
               context: { current_user: user, current_account: account }
      )
      expect(response.to_h).to eq result
    end
  end

  context 'when no current user' do
    let(:result) do
      {
        'data' => { 'objectiveCreate' => nil },
        'errors' => [{
          'locations' => [{ 'column' => 3, 'line' => 2 }],
          'message' => 'An object of type Mutation was hidden due to permissions',
          'path' => ['objectiveCreate']
        }]
      }
    end

    it 'returns authorization error' do
      response = MyTeamChurchApiSchema.execute(
        query, variables: { input: },
               context: { current_account: account }
      )
      expect(response.to_h).to eq result
    end
  end
end
