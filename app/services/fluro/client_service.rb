# frozen_string_literal: true

module Fluro
  class ClientService
    include HTTParty
    base_uri 'https://api.fluro.io'

    def initialize(api_key)
      @options = { headers: { authorization: "Bearer #{api_key}" } }
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

    def session
      self.class.get('/session', @options)
    end

    def account(id)
      self.class.get("/account/#{id}", @options)
    end
  end
end
