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
        collection.each do |remote_item|
          import_item(remote_item)
        end
      end

      def connect_realms(remote, local)
        @organization.realms.where(remote_id: remote['realms'].pluck('_id')).each do |realm|
          local.realms << realm
        end
      end
    end
  end
end
