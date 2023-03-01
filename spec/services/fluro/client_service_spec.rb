# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Fluro::ClientService do
  subject(:client_service) { described_class.new(account) }

  let(:account) { create(:account, fluro_api_key: 'fluro_api_key') }

  describe '#contacts' do
    before do
      allow(described_class).to receive(:get).and_return([])
    end

    it 'calls the api' do
      client_service.contacts
      expect(described_class).to have_received(:get).with(
        '/content/contact?allDefinitions=true',
        { headers: { authorization: "Bearer #{account.fluro_api_key}" } }
      )
    end

    it 'returns list of contacts' do
      expect(client_service.contacts).to eq([])
    end
  end

  describe '#teams' do
    before do
      allow(described_class).to receive(:get).and_return([])
    end

    it 'calls the api' do
      client_service.teams
      expect(described_class).to have_received(:get).with(
        '/content/team?allDefinitions=true',
        { headers: { authorization: "Bearer #{account.fluro_api_key}" } }
      )
    end

    it 'returns list of teams' do
      expect(client_service.teams).to eq([])
    end
  end

  describe '#realms' do
    before do
      allow(described_class).to receive(:get).and_return([])
    end

    it 'calls the api' do
      client_service.realms
      expect(described_class).to have_received(:get).with(
        '/content/realm?allDefinitions=true',
        { headers: { authorization: "Bearer #{account.fluro_api_key}" } }
      )
    end

    it 'returns list of realms' do
      expect(client_service.realms).to eq([])
    end
  end
end
