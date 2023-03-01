# frozen_string_literal: true

module Fluro
  class ImportService
    attr_reader :account

    def initialize(account)
      @account = account
    end

    def self.import(account)
      new(account).import
    end

    def import
      Fluro::Import::RealmService.import(account)
      Fluro::Import::ContactService.import(account)
      Fluro::Import::TeamService.import(account)
    end
  end
end
