# frozen_string_literal: true

module Types
  module Enums
    module Objective
      class ProgressType < Types::BaseEnum
        description 'objective progress enum'

        ::Objective.progresses.each do |key, _value|
          value key
        end
      end
    end
  end
end
