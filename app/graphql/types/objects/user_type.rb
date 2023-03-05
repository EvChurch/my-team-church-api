# frozen_string_literal: true

module Types
  class Objects::UserType < Types::BaseObject
    field :id, ID, 'record unique identifier', null: false
  end
end
