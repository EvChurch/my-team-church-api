# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Mutations::User::LoginMutation, vcr: {
  cassette_name: 'mutations/user_login_mutation', match_requests_on: [:body]
} do
  let!(:account) { create(:account, remote_id: 'remote_account_id') }
  let(:query) { <<~GRAPHQL }
    mutation($input: UserLoginMutationInput!) {
      userLogin(input: $input) {
        user {
          id
          title
          firstName
          lastName
          email
          phoneNumber
          createdAt
        }
        expiresAt
        token
      }
    }
  GRAPHQL
  let(:result) do
    user = User.find_by(remote_id: 'remote_user_id')
    {
      'data' => {
        'userLogin' => {
          'token' => JsonWebTokenService.encode({ user_id: user.id, account_id: account.id }, 30.days.from_now),
          'expiresAt' => 30.days.from_now.iso8601,
          'user' => {
            'createdAt' => '2018-12-03T10:30:14Z',
            'email' => 'bob.jones@example.com',
            'firstName' => 'Bob',
            'id' => user.id,
            'lastName' => 'Jones',
            'phoneNumber' => '+6421000111',
            'title' => 'Bob Jones'
          }
        }
      }
    }
  end

  before do
    travel_to Time.zone.local(1994)
    create(:application, api_key: 'api_key')
  end

  it 'returns a valid user' do
    credentials = { username: 'bob.jones@example.com', password: 'ultra-secure-password' }
    input = { credentials:, accountSlug: account.slug }
    response = MyTeamChurchApiSchema.execute(query, variables: { input: })
    expect(response.to_h).to eq result
  end

  context 'when account does not match user' do
    let(:result) do
      {
        'data' => {
          'userLogin' => nil
        },
        'errors' => [
          {
            'message' => 'Invalid Account ID',
            'locations' => [
              {
                'line' => 2,
                'column' => 3
              }
            ],
            'path' => [
              'userLogin'
            ]
          }
        ]
      }
    end

    it 'returns an invalid account id error' do
      credentials = { username: 'mike.smith@example.com', password: 'different-account-password' }
      input = { credentials:, accountSlug: account.slug }
      response = MyTeamChurchApiSchema.execute(query, variables: { input: })
      expect(response.to_h).to eq result
    end
  end

  context 'when username and password is wrong' do
    let(:result) do
      {
        'data' => {
          'userLogin' => nil
        },
        'errors' => [
          {
            'message' => 'Login Failed. Please check your email address and password.',
            'locations' => [
              {
                'line' => 2,
                'column' => 3
              }
            ],
            'path' => [
              'userLogin'
            ]
          }
        ]
      }
    end

    it 'returns an invalid account id error' do
      credentials = { username: 'bob.jones@example.com', password: 'incorrect' }
      input = { credentials:, accountSlug: account.slug }
      response = MyTeamChurchApiSchema.execute(query, variables: { input: })
      expect(response.to_h).to eq result
    end
  end
end
