# frozen_string_literal: true

module Fluro
  class ImportService
    attr_reader :organization

    def initialize(organization)
      @organization = organization
    end

    def self.import(organization)
      new(organization).import
    end

    def import
      Fluro::Import::RealmService.import(organization)
      Fluro::Import::ContactService.import(organization)
      Fluro::Import::TeamService.import(organization)
    end
  end
end
