# frozen_string_literal: true

module Types
  module Enums
    module Objective
      module Activity
        class KindType < Types::BaseEnum
          graphql_name 'ObjectiveActivityKind'
          description 'activity kind enum'

          ::Objective::Activity.kinds.each do |key, _value|
            value key
          end
        end
      end
    end
  end
end
