# frozen_string_literal: true

module Fluro
  module Import
    class PositionService < Fluro::Import::BaseService
      def import
        @client.positions.each do |position|
          binding.pry
          position
        end
      end
    end
  end
end
