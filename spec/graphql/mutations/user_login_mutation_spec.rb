# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Mutations::UserLoginMutation, vcr: {
  cassette_name: 'mutations/user_login_mutation', match_requests_on: [:body]
} do
  before { travel_to Time.zone.local(1994) }

  let(:account) { create(:account, remote_id: 'remote_account_id') }
  let(:application) { create(:application, account:, api_key: 'api_key') }
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
        token
      }
    }
  GRAPHQL
  let(:result) do
    user = User.find_by(remote_id: 'remote_user_id')
    {
      'data' => {
        'userLogin' => {
          'token' => JsonWebTokenService.encode(user_id: user.id),
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

  it 'returns a valid user' do
    input = { username: 'bob.jones@example.com', password: 'ultra-secure-password' }
    response = MyTeamChurchApiSchema.execute(
      query, variables: { input: }, context: { current_account: account }
    )
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
      input = { username: 'mike.smith@example.com', password: 'different-account-password' }
      response = MyTeamChurchApiSchema.execute(
        query, variables: { input: }, context: { current_account: account }
      )
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
      input = { username: 'bob.jones@example.com', password: 'incorrect' }
      response = MyTeamChurchApiSchema.execute(
        query, variables: { input: }, context: { current_account: account }
      )
      expect(response.to_h).to eq result
    end
  end
end
