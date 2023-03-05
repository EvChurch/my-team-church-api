# frozen_string_literal: true

module Mutations
  class UserLoginMutation < BaseMutation
    description 'Authenticate a User'

    field :user, Types::Objects::UserType, null: true

    argument :user_login_input, Types::Inputs::UserLoginInputType, required: true

    def resolve(user_login_input:)
      client = Fluro::ClientService.new(context[:current_account].applications.first)
      user = client.login(user_login_input.username, user_login_input.password, context[:current_account].remote_id)

      team = ::Team.new(**team_input)
      raise GraphQL::ExecutionError.new 'Error creating team', extensions: team.errors.to_hash unless team.save

      { team: }
    end
  end
end
