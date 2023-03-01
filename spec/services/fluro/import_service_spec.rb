# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Fluro::ImportService do
  subject(:import_service) { described_class.new(account) }

  let(:account) { create(:account, fluro_api_key: 'fluro_api_key') }

  describe '.import' do
    let!(:instance) { described_class.new(account) }

    before do
      allow(described_class).to receive(:new).and_return(instance)
      allow(instance).to receive(:import)
    end

    it 'creates an instance' do
      described_class.import(account)
      expect(described_class).to have_received(:new).with(account)
    end

    it 'calls import' do
      described_class.import(account)
      expect(instance).to have_received(:import)
    end
  end

  describe '#account' do
    it 'returns account' do
      expect(import_service.account).to eq account
    end
  end

  describe '#import' do
    before do
      allow(Fluro::Import::RealmService).to receive(:import)
      allow(Fluro::Import::ContactService).to receive(:import)
      allow(Fluro::Import::TeamService).to receive(:import)
    end

    it 'calls realm service' do
      import_service.import
      expect(Fluro::Import::RealmService).to have_received(:import).with(account)
    end

    it 'calls contact service' do
      import_service.import
      expect(Fluro::Import::ContactService).to have_received(:import).with(account)
    end

    it 'calls team service' do
      import_service.import
      expect(Fluro::Import::TeamService).to have_received(:import).with(account)
    end
  end
end
