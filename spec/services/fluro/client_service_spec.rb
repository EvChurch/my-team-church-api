# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Fluro::ClientService do
  subject(:client_service) { described_class.new(api_key) }

  let(:api_key) { 'fluro_api_key' }
  let(:options) do
    { headers: { 'Content-Type' => 'application/json', authorization: "Bearer #{api_key}" } }
  end

  describe '#contacts' do
    before do
      allow(described_class).to receive(:get).and_return([])
    end

    it 'calls the api' do
      client_service.contacts
      expect(described_class).to have_received(:get).with('/content/contact?allDefinitions=true', options)
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
      expect(described_class).to have_received(:get).with('/content/team?allDefinitions=true', options)
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
      expect(described_class).to have_received(:get).with('/content/realm?allDefinitions=true', options)
    end

    it 'returns list of realms' do
      expect(client_service.realms).to eq([])
    end
  end

  describe '#session' do
    before do
      allow(described_class).to receive(:get).and_return({})
    end

    it 'calls the api' do
      client_service.session
      expect(described_class).to have_received(:get).with('/session', options)
    end

    it 'returns current session' do
      expect(client_service.session).to eq({})
    end

    describe '#account' do
      before do
        allow(described_class).to receive(:get).and_return({ _id: 'accountId' })
      end

      it 'calls the api' do
        client_service.account('accountId')
        expect(described_class).to have_received(:get).with('/account/accountId', options)
      end

      it 'returns the requested account' do
        expect(client_service.account('accountId')).to eq({ _id: 'accountId' })
      end
    end

    describe '#login' do
      let(:options) do
        { headers: { 'Content-Type' => 'application/json', authorization: "Bearer #{api_key}" },
          body: { username: 'username', password: 'password', account: 'accountId' }.to_json }
      end

      before do
        allow(described_class).to receive(:post).and_return({ _id: 'userId' })
      end

      it 'calls the api' do
        client_service.login('username', 'password', 'accountId')
        expect(described_class).to have_received(:post).with('/token/login', options)
      end

      it 'returns an authenticated user' do
        expect(client_service.login('username', 'password', 'accountId')).to eq({ _id: 'userId' })
      end
    end

    describe '#avatar' do
      let(:ok) { true }

      before do
        allow(described_class).to receive(:get).and_return(
          instance_double(HTTParty::Response, body: 'avatar', ok?: ok)
        )
      end

      it 'calls the api' do
        client_service.avatar('contact', 'contactId')
        expect(described_class).to have_received(:get).with(
          "/get/avatar/contact/contactId?access_token=#{api_key}&w=40&h=40"
        )
      end

      it 'returns the avatar' do
        expect(Base64.strict_decode64(client_service.avatar('contact', 'contactId'))).to eq('avatar')
      end

      context 'when not ok' do
        let(:ok) { false }

        it 'returns nil' do
          expect(client_service.avatar('contact', 'contactId')).to be_nil
        end
      end
    end
  end
end
