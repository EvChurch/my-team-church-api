# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Fluro::ImportService do
  subject(:import_service) { described_class.new(application) }

  let(:account) { create(:account) }
  let(:application) { create(:application, account:, api_key: 'fluro_api_key') }

  describe '.import' do
    let!(:instance) { described_class.new(application) }

    before do
      allow(described_class).to receive(:new).and_return(instance)
      allow(instance).to receive(:import_all)
    end

    it 'creates an instance' do
      described_class.import_all(application)
      expect(described_class).to have_received(:new).with(application)
    end

    it 'calls import' do
      described_class.import_all(application)
      expect(instance).to have_received(:import_all)
    end
  end

  describe '#application' do
    it 'returns account' do
      expect(import_service.application).to eq application
    end
  end

  describe '#import_all' do
    before do
      allow(Fluro::Import::RealmService).to receive(:import_all)
      allow(Fluro::Import::ContactService).to receive(:import_all)
      allow(Fluro::Import::TeamService).to receive(:import_all)
    end

    it 'calls realm service' do
      import_service.import_all
      expect(Fluro::Import::RealmService).to have_received(:import_all).with(application)
    end

    it 'calls contact service' do
      import_service.import_all
      expect(Fluro::Import::ContactService).to have_received(:import_all).with(application)
    end

    it 'calls team service' do
      import_service.import_all
      expect(Fluro::Import::TeamService).to have_received(:import_all).with(application)
    end
  end
end
