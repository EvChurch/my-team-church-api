# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Resolvers::Team::PositionResolver do
  let!(:account) { create(:account) }
  let(:user) { create(:user, contacts: [contact]) }
  let(:contact) { create(:contact) }
  let(:team) { create(:team, contacts: [contact], visible_members: true) }
  let!(:position) { create(:team_position, team:, remote_id: 'team_position_id') }
  let!(:assignment) { create(:team_assignment, position:, contact:) }
  let(:query) { <<~GRAPHQL }
    query($teamId: ID!, $id: ID!) {
      teamPosition(teamId: $teamId, id: $id) {
        assignmentsCount
        assignments {
          nodes {
            contact { id }
            createdAt
            id
            position { id }
            progress
            updatedAt
          }
        }
        contacts {
          nodes { id }
        }
        createdAt
        exclude
        id
        progress
        remoteId
        reporter
        requiredAssignmentsCount
        slug
        title
        updatedAt
      }
    }
  GRAPHQL
  let(:result) do
    {
      'data' => { 'teamPosition' => {
        'assignmentsCount' => 1,
        'assignments' => { 'nodes' => [{
          'contact' => { 'id' => contact.id },
          'createdAt' => assignment.created_at.iso8601,
          'id' => assignment.id,
          'position' => { 'id' => position.id },
          'progress' => 'no_status',
          'updatedAt' => assignment.updated_at.iso8601
        }] },
        'contacts' => { 'nodes' => [{ 'id' => contact.id }] },
        'createdAt' => position.created_at.iso8601,
        'exclude' => false,
        'id' => position.id,
        'progress' => 'no_status',
        'remoteId' => 'team_position_id',
        'reporter' => false,
        'requiredAssignmentsCount' => 0,
        'slug' => position.slug,
        'title' => position.title,
        'updatedAt' => position.updated_at.iso8601
      } }
    }
  end

  it 'returns position of selected team' do
    response = MyTeamChurchApiSchema.execute(
      query, context: { current_account: account, current_user: user },
             variables: { teamId: team.id, id: position.id }
    )
    expect(response.to_h).to eq result
  end

  context 'when ids are slugs' do
    it 'returns position of selected team' do
      response = MyTeamChurchApiSchema.execute(
        query, context: { current_account: account, current_user: user },
               variables: { teamId: team.slug, id: position.slug }
      )
      expect(response.to_h).to eq result
    end
  end

  context 'when user is team member of invisible team' do
    let(:team) { create(:team, contacts: [contact]) }
    let(:result) do
      {
        'data' => nil,
        'errors' => [{
          'locations' => [{ 'column' => 3, 'line' => 2 }],
          'message' => 'Position not found',
          'path' => ['teamPosition']
        }]
      }
    end

    it 'returns not found' do
      response = MyTeamChurchApiSchema.execute(
        query, variables: { teamId: team.id, id: position.id },
               context: { current_account: account, current_user: user }
      )
      expect(response.to_h).to eq result
    end
  end

  context 'when team id is unknown' do
    let(:result) do
      {
        'data' => nil,
        'errors' => [{
          'locations' => [{ 'column' => 3, 'line' => 2 }],
          'message' => 'Position not found',
          'path' => ['teamPosition']
        }]
      }
    end

    it 'returns not found' do
      response = MyTeamChurchApiSchema.execute(
        query, context: { current_account: account, current_user: user },
               variables: { teamId: SecureRandom.uuid, id: position.id }
      )
      expect(response.to_h).to eq result
    end
  end

  context 'when position id is unknown' do
    let(:result) do
      {
        'data' => nil,
        'errors' => [{
          'locations' => [{ 'column' => 3, 'line' => 2 }],
          'message' => 'Position not found',
          'path' => ['teamPosition']
        }]
      }
    end

    it 'returns not found' do
      response = MyTeamChurchApiSchema.execute(
        query, context: { current_account: account, current_user: user },
               variables: { teamId: team.id, id: SecureRandom.uuid }
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
          'path' => ['teamPosition']
        }]
      }
    end

    it 'returns authorization error' do
      response = MyTeamChurchApiSchema.execute(query, variables: { teamId: team.id, id: position.id })
      expect(response.to_h).to eq result
    end
  end
end
