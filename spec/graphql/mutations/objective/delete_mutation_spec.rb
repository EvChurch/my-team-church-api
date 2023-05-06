# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Mutations::Objective::DeleteMutation do
  let(:account) { create(:account) }
  let(:user) { create(:user,  contacts: [contact]) }
  let(:team) { create(:team,  contacts: [contact], visible_members: true) }
  let(:contact) { create(:contact) }
  let!(:objective) { create(:objective, team:, contact:) }
  let(:query) { <<~GRAPHQL }
    mutation($id: ID!) {
      objectiveDelete(input: { id: $id }) {
        id
      }
    }
  GRAPHQL
  let(:result) do
    {
      'data' => {
        'objectiveDelete' => {
          'id' => objective.id
        }
      }
    }
  end

  it 'deletes an objective' do
    response = MyTeamChurchApiSchema.execute(
      query, variables: { id: objective.id },
             context: { current_user: user, current_account: account }
    )
    expect(response.to_h).to eq result
  end

  context 'when user is not member of team' do
    let(:team) { create(:team, visible_members: false) }
    let(:result) do
      {
        'data' => { 'objectiveDelete' => nil },
        'errors' => [{
          'locations' => [{ 'column' => 3, 'line' => 2 }],
          'message' => 'An object of type Mutation was hidden due to permissions',
          'path' => ['objectiveDelete']
        }]
      }
    end

    it 'returns authorization error' do
      response = MyTeamChurchApiSchema.execute(
        query, variables: { id: objective.id },
               context: { current_user: user, current_account: account }
      )
      expect(response.to_h).to eq result
    end
  end

  context 'when no current user' do
    let(:result) do
      {
        'data' => { 'objectiveDelete' => nil },
        'errors' => [{
          'locations' => [{ 'column' => 3, 'line' => 2 }],
          'message' => 'An object of type Mutation was hidden due to permissions',
          'path' => ['objectiveDelete']
        }]
      }
    end

    it 'returns authorization error' do
      response = MyTeamChurchApiSchema.execute(
        query, variables: { id: objective.id },
               context: { current_account: account }
      )
      expect(response.to_h).to eq result
    end
  end
end
