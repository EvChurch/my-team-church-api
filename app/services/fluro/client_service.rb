# frozen_string_literal: true

module Fluro
  class ClientService
    include HTTParty
    base_uri 'https://api.fluro.io'

    def initialize(organization)
      @organization = organization
      @options = { headers: { authorization: "Bearer #{organization.fluro_api_key}" } }
    end

    def contacts
      self.class.get('/content/contact', @options)
    end

    def teams
      self.class.get('/content/ministryTeam', @options)
    end

    def realms
      self.class.get('/realm/tree', @options)
    end
  end
end
