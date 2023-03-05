# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Application do
  subject(:application) { create(:application) }

  it { is_expected.to have_many(:realm_connections).dependent(:delete_all) }
  it { is_expected.to have_many(:realms).through(:realm_connections) }
  it { is_expected.to validate_presence_of(:title) }
  it { is_expected.to validate_presence_of(:definition) }
  it { is_expected.to validate_uniqueness_of(:remote_id).scoped_to(:account_id).allow_nil }

  describe '#import' do
    it 'calls import_all with application' do
      allow(Fluro::ImportService).to receive(:import_all)
      application.import
      expect(Fluro::ImportService).to have_received(:import_all).with(application)
    end
  end

  describe '#should_generate_new_friendly_id?' do
    it 'updates slug when title changes' do
      application.update(title: 'this is a test')
      expect(application.slug).to eq 'this-is-a-test'
    end
  end
end
