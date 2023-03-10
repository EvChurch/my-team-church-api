# frozen_string_literal: true

module Types
  module Inputs
    class UserCredentialsInputType < Types::BaseInputObject
      description 'Credentials of the user'

      argument :password, String, 'Password of the user', required: true
      argument :username, String, 'Username of the user', required: true
    end
  end
end
