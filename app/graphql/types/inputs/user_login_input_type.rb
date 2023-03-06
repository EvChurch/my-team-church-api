# frozen_string_literal: true

module Types
  module Inputs
    class UserLoginInputType < Types::BaseInputObject
      description 'User credentials (passed to fluro with current account)'

      argument :password, String, 'Password of the user'
      argument :username, String, 'Username of the user'
    end
  end
end
