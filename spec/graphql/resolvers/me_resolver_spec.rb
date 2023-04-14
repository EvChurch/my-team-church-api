# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Resolvers::MeResolver do
  let!(:account) { create(:account, remote_id: 'remote_account_id') }
  let(:user) { create(:user, remote_id: 'remote_user_id') }
  let(:query) { <<~GRAPHQL }
    query {
      me {
        account {
          id
        }
        avatar
        contacts {
          id
        }
        createdAt
        email
        firstName
        id
        lastName
        phoneNumber
        remoteId
        slug
        teams {
          id
        }
        title
        updatedAt
      }
    }
  GRAPHQL
  let(:result) do
    {
      'data' => {
        'me' => {
          'account' => { 'id' => account.id },
          'avatar' => "data:image/png;base64,#{user.avatar}",
          'contacts' => [],
          'createdAt' => user.created_at.iso8601,
          'email' => user.email,
          'firstName' => user.first_name,
          'id' => user.id,
          'lastName' => user.last_name,
          'phoneNumber' => user.phone_number,
          'remoteId' => 'remote_user_id',
          'slug' => user.slug,
          'teams' => [],
          'title' => user.title,
          'updatedAt' => user.updated_at.iso8601
        }
      }
    }
  end

  it 'returns current_user' do
    response = MyTeamChurchApiSchema.execute(query, context: { current_account: account, current_user: user })
    expect(response.to_h).to eq result
  end

  context 'when no current user' do
    let(:result) do
      {
        'data' => nil,
        'errors' => [{
          'locations' => [{ 'column' => 3, 'line' => 2 }],
          'message' => 'An object of type Query was hidden due to permissions',
          'path' => ['me']
        }]
      }
    end

    it 'returns authorization error' do
      response = MyTeamChurchApiSchema.execute(query)
      expect(response.to_h).to eq result
    end
  end
end
