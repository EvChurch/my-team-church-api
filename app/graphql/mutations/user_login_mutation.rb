# frozen_string_literal: true

module Mutations
  class UserLoginMutation < BaseMutation
    description 'Authenticate a User'

    field :user, Types::Objects::UserType, 'user if credentials are valid', null: true

    argument :user_login_input, Types::Inputs::UserLoginInputType,
             'user credentials (passed to fluro to authenticate)', required: true

    def resolve(user_login_input:)
      client = Fluro::ClientService.new(context[:current_account].applications.first)
      remote_user = client.login(user_login_input.username, user_login_input.password,
                                 context[:current_account].remote_id)
      if remote_user.body == 'Invalid Account ID'
        raise GraphQL::ExecutionError,
              'User is not associated with Fluro account.'
      end
      raise GraphQL::ExecutionError, remote_user['message'] if remote_user.code != 200

      user = User.login(remote_user)

      { user: }
    end
  end
end
