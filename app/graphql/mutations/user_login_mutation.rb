# frozen_string_literal: true

module Mutations
  class UserLoginMutation < BaseMutation
    description 'Authenticate a User'

    field :token, String, 'token to use as Authorization header as: Bearer \'token\'', null: true
    field :user, Types::Objects::UserType, 'user if credentials are valid', null: true

    argument :password, String, 'Password of the user', required: true
    argument :username, String, 'Username of the user', required: true

    def resolve(password:, username:)
      client = Fluro::ClientService.new(context[:current_account].applications.first)
      response = client.login(username, password, context[:current_account].remote_id)
      validate!(response)
      User.login(response.parsed_response)
    end

    private

    def validate!(response)
      raise GraphQL::ExecutionError, response['message'] || response.body if response.code != 200
    end
  end
end
