# frozen_string_literal: true

module Mutations
  class UserLoginMutation < BaseMutation
    description 'authenticate a user'

    field :token, String, 'token to use as Authorization header as: Bearer \'token\'', null: true
    field :user, Types::Objects::UserType, 'user if credentials are valid', null: true

    argument :account_slug, String, 'slug of account', required: true
    argument :credentials, Types::Inputs::UserCredentialsInputType, 'Credentials of the user', required: true

    def resolve(account_slug:, credentials:)
      account = Account.friendly.find(account_slug)
      MultiTenant.with(account) do
        client = Fluro::ClientService.new(account.application.api_key)
        response = client.login(credentials.username, credentials.password, account.remote_id)
        validate!(response)
        User.login(client, response.parsed_response)
      end
    rescue ActiveRecord::RecordNotFound
      raise GraphQL::ExecutionError, 'Invalid Account ID'
    end

    protected

    def validate!(response)
      raise GraphQL::ExecutionError, response['message'] || response.body if response.code != 200
    end
  end
end
