# frozen_string_literal: true

module Fluro
  module Import
    class BaseService
      def initialize(organization)
        @organization = organization
        @client = Fluro::ClientService.new(organization)
      end

      def self.import(organization)
        new(organization).import
      end

      def import
        Fluro::Import::RealmService.import(@organization)
        Fluro::Import::ContactService.import(@organization)
        Fluro::Import::PositionService.import(@organization)
      end
    end
  end
end
