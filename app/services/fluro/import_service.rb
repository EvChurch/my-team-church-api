# frozen_string_literal: true

module Fluro
  class ImportService
    attr_reader :application

    def initialize(application)
      @application = application
    end

    def self.import_all(application)
      new(application).import_all
    end

    def import_all
      Fluro::Import::RealmService.import_all(application)
      Fluro::Import::ContactService.import_all(application)
      Fluro::Import::TeamService.import_all(application)
    end
  end
end
