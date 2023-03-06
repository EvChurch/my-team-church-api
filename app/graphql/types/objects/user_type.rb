# frozen_string_literal: true

module Types
  module Objects
    class UserType < Types::BaseObject
      field :id, ID, 'record unique identifier', null: false
    end
  end
end
