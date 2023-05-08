# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Mutations::EarlyAccess::CreateMutation do
  let(:query) { <<~GRAPHQL }
    mutation($input: EarlyAccessCreateMutationInput!) {
      earlyAccessCreate(input: $input) {
        earlyAccess {
          id
          createdAt
          emailAddress
          firstName
          updatedAt
        }
      }
    }
  GRAPHQL
  let(:input) do
    {
      earlyAccess: {
        emailAddress: 'john@example.com',
        firstName: 'first name'
      }
    }
  end
  let(:result) do
    early_access = EarlyAccess.find_by(email_address: 'john@example.com')
    {
      'data' => {
        'earlyAccessCreate' => {
          'earlyAccess' => {
            'createdAt' => early_access.created_at.iso8601,
            'emailAddress' => 'john@example.com',
            'firstName' => 'first name',
            'id' => early_access.id,
            'updatedAt' => early_access.updated_at.iso8601
          }
        }
      }
    }
  end

  it 'returns an early access' do
    response = MyTeamChurchApiSchema.execute(
      query, variables: { input: }
    )

    expect(response.to_h).to eq result
  end

  context 'when email address already exists' do
    before { create(:early_access, email_address: 'john@example.com') }

    let(:result) do
      {
        'data' => { 'earlyAccessCreate' => nil },
        'errors' => [{
          'locations' => [{ 'column' => 3, 'line' => 2 }],
          'message' => 'Validation failed: Email address has already been taken.',
          'path' => ['earlyAccessCreate']
        }]
      }
    end

    it 'returns validation error' do
      response = MyTeamChurchApiSchema.execute(
        query, variables: { input: }
      )

      expect(response.to_h).to eq result
    end
  end
end
