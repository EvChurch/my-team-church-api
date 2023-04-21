# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Mutations::Objective::Activity::CreateMutation do
  let(:account) { create(:account, remote_id: 'remote_account_id') }
  let(:user) { create(:user, contacts: [contact]) }
  let!(:team) { create(:team, contacts: [contact], visible_members: true) }
  let(:objective) { create(:objective, team:, contact:) }
  let(:objective_result) { create(:objective_result, objective:, contact:) }
  let(:contact) { create(:contact) }
  let(:query) { <<~GRAPHQL }
    mutation($input: ObjectiveActivityCreateMutationInput!) {
      objectiveActivityCreate(input: $input) {
        activity {
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
    }
  GRAPHQL
  let(:input) do
    {
      activity: {
        comment: 'unique comment',
        contactId: contact.id,
        currentValue: 1,
        kind: 'progress_update',
        objectiveId: objective.id,
        progress: 'on_track',
        resultId: objective_result.id
      }
    }
  end
  let(:result) do
    activity = Objective::Activity.find_by(comment: 'unique comment')
    {
      'data' => {
        'objectiveActivityCreate' => {
          'activity' => {
            'account' => { 'id' => account.id },
            'comment' => 'unique comment',
            'contact' => { 'id' => contact.id },
            'createdAt' => objective_result.created_at.iso8601,
            'currentValue' => 1.0,
            'id' => activity.id,
            'kind' => 'progress_update',
            'objective' => { 'id' => objective.id },
            'progress' => 'on_track',
            'result' => { 'id' => objective_result.id },
            'updatedAt' => activity.updated_at.iso8601
          }
        }
      }
    }
  end

  it 'returns an activity' do
    response = MyTeamChurchApiSchema.execute(
      query, variables: { input: },
             context: { current_user: user, current_account: account }
    )
    expect(response.to_h).to eq result
  end

  context 'when contact is not a member of team' do
    let(:result) do
      {
        'data' => { 'objectiveActivityCreate' => nil },
        'errors' => [{
          'locations' => [{ 'column' => 3, 'line' => 2 }],
          'message' => 'Validation failed: Contact contact must be member of team.',
          'path' => ['objectiveActivityCreate']
        }]
      }
    end

    it 'returns validation error' do
      input[:activity][:contactId] = create(:contact).id
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
        'data' => { 'objectiveActivityCreate' => nil },
        'errors' => [{
          'locations' => [{ 'column' => 3, 'line' => 2 }],
          'message' => 'An object of type Mutation was hidden due to permissions',
          'path' => ['objectiveActivityCreate']
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

  context 'when objective cannot be found' do
    let(:result) do
      {
        'data' => { 'objectiveActivityCreate' => nil },
        'errors' => [{
          'locations' => [{ 'column' => 3, 'line' => 2 }],
          'message' => 'ObjectiveActivityCreateMutationPayload not found',
          'path' => ['objectiveActivityCreate']
        }]
      }
    end

    before do
      input[:activity][:objectiveId] = SecureRandom.uuid
    end

    it 'returns not found error' do
      response = MyTeamChurchApiSchema.execute(
        query, variables: { input: },
               context: { current_user: user, current_account: account }
      )
      expect(response.to_h).to eq result
    end
  end

  context 'when result cannot be found' do
    let(:result) do
      {
        'data' => { 'objectiveActivityCreate' => nil },
        'errors' => [{
          'locations' => [{ 'column' => 3, 'line' => 2 }],
          'message' => "Validation failed: Result can't be blank.",
          'path' => ['objectiveActivityCreate']
        }]
      }
    end

    before do
      input[:activity][:resultId] = SecureRandom.uuid
    end

    it 'returns not found error' do
      response = MyTeamChurchApiSchema.execute(
        query, variables: { input: },
               context: { current_user: user, current_account: account }
      )
      expect(response.to_h).to eq result
    end
  end

  context 'when contact cannot be found' do
    let(:result) do
      {
        'data' => { 'objectiveActivityCreate' => nil },
        'errors' => [{
          'locations' => [{ 'column' => 3, 'line' => 2 }],
          'message' => 'Validation failed: Contact must exist.',
          'path' => ['objectiveActivityCreate']
        }]
      }
    end

    before do
      input[:activity][:contactId] = SecureRandom.uuid
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
        'data' => { 'objectiveActivityCreate' => nil },
        'errors' => [{
          'locations' => [{ 'column' => 3, 'line' => 2 }],
          'message' => 'An object of type Mutation was hidden due to permissions',
          'path' => ['objectiveActivityCreate']
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
