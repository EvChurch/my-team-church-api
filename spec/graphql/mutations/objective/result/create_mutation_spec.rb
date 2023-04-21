# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Mutations::Objective::Result::CreateMutation do
  let(:account) { create(:account, remote_id: 'remote_account_id') }
  let(:user) { create(:user, contacts: [contact]) }
  let!(:team) { create(:team, contacts: [contact], visible_members: true) }
  let(:objective) { create(:objective, team:, contact:) }
  let(:contact) { create(:contact) }
  let(:query) { <<~GRAPHQL }
    mutation($input: ObjectiveResultCreateMutationInput!) {
      objectiveResultCreate(input: $input) {
        result {
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
    }
  GRAPHQL
  let(:input) do
    {
      result: {
        contactId: contact.id,
        description: 'description',
        dueAt: '2019-01-01',
        kind: 'key_result',
        measurement: 'numerical',
        objectiveId: objective.id,
        startAt: '2019-01-01',
        startValue: 1,
        status: 'draft',
        targetValue: 99,
        title: 'title'
      }
    }
  end
  let(:result) do
    objective_result = Objective::Result.find_by(title: 'title')
    {
      'data' => {
        'objectiveResultCreate' => {
          'result' => {
            'account' => { 'id' => account.id },
            'activities' => [],
            'contact' => { 'id' => contact.id },
            'createdAt' => objective_result.created_at.iso8601,
            'currentValue' => nil,
            'description' => 'description',
            'dueAt' => '2019-01-01',
            'id' => objective_result.id,
            'kind' => 'key_result',
            'measurement' => 'numerical',
            'objective' => { 'id' => objective.id },
            'percentage' => 0,
            'progress' => 'no_status',
            'startAt' => '2019-01-01',
            'startValue' => 1.0,
            'status' => 'draft',
            'targetValue' => 99.0,
            'title' => 'title',
            'updatedAt' => objective_result.updated_at.iso8601
          }
        }
      }
    }
  end

  it 'returns a result' do
    response = MyTeamChurchApiSchema.execute(
      query, variables: { input: },
             context: { current_user: user, current_account: account }
    )
    expect(response.to_h).to eq result
  end

  context 'when contact is not a member of team' do
    let(:result) do
      {
        'data' => { 'objectiveResultCreate' => nil },
        'errors' => [{
          'locations' => [{ 'column' => 3, 'line' => 2 }],
          'message' => 'Validation failed: Contact contact must be member of team.',
          'path' => ['objectiveResultCreate']
        }]
      }
    end

    it 'returns validation error' do
      input[:result][:contactId] = create(:contact).id
      response = MyTeamChurchApiSchema.execute(
        query, variables: { input: }, context: { current_user: user, current_account: account }
      )
      expect(response.to_h).to eq result
    end
  end

  context 'when user is not member of team' do
    let(:user) { create(:user) }
    let(:result) do
      {
        'data' => { 'objectiveResultCreate' => nil },
        'errors' => [{
          'locations' => [{ 'column' => 3, 'line' => 2 }],
          'message' => 'An object of type Mutation was hidden due to permissions',
          'path' => ['objectiveResultCreate']
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

  context 'when no objective' do
    let(:result) do
      {
        'data' => { 'objectiveResultCreate' => nil },
        'errors' => [{
          'locations' => [{ 'column' => 3, 'line' => 2 }],
          'message' => 'ObjectiveResultCreateMutationPayload not found',
          'path' => ['objectiveResultCreate']
        }]
      }
    end

    before do
      input[:result][:objectiveId] = SecureRandom.uuid
    end

    it 'returns not found error' do
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
        'data' => { 'objectiveResultCreate' => nil },
        'errors' => [{
          'locations' => [{ 'column' => 3, 'line' => 2 }],
          'message' => 'An object of type Mutation was hidden due to permissions',
          'path' => ['objectiveResultCreate']
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
