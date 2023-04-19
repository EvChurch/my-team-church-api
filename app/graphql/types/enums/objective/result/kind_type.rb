# frozen_string_literal: true

module Types
  module Enums
    module Objective
      module Result
        class KindType < Types::BaseEnum
          description 'result kind enum'

          ::Objective::Result.kinds.each do |key, _value|
            value key
          end
        end
      end
    end
  end
end
