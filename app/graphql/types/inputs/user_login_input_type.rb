# frozen_string_literal: true

module Types
  class Inputs::UserLoginInputType < Types::BaseInputObject
    argument :password, String, 'Password of the user'
    argument :username, String, 'Username of the user'
  end
end
