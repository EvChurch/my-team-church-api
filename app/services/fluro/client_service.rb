# frozen_string_literal: true

module Fluro
  class ClientService
    include HTTParty
    base_uri 'https://api.fluro.io'

    def initialize(account)
      @options = { headers: { authorization: "Bearer #{account.fluro_api_key}" } }
    end

    def contacts
      self.class.get('/content/contact?allDefinitions=true', @options)
    end

    def teams
      self.class.get('/content/team?allDefinitions=true', @options)
    end

    def realms
      self.class.get('/content/realm?allDefinitions=true', @options)
    end
  end
end
