# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Account do
  subject(:account) { create(:account) }

  it { is_expected.to have_db_column(:title).of_type(:string).with_options(null: false) }
  it { is_expected.to have_db_column(:slug).of_type(:string).with_options(null: false) }
  it { is_expected.to have_db_column(:created_at).of_type(:datetime).with_options(null: false) }
  it { is_expected.to have_db_column(:updated_at).of_type(:datetime).with_options(null: false) }
  it { is_expected.to have_many(:applications).dependent(:delete_all) }
  it { is_expected.to have_many(:contacts).dependent(:delete_all) }
  it { is_expected.to have_many(:realms).dependent(:delete_all) }
  it { is_expected.to have_many(:realm_connections).dependent(:delete_all) }
  it { is_expected.to have_many(:teams).dependent(:delete_all) }
  it { is_expected.to have_many(:team_memberships).dependent(:delete_all) }
  it { is_expected.to validate_presence_of(:title) }
  it { is_expected.to validate_uniqueness_of(:remote_id).allow_nil }

  describe '.import_all' do
    it 'calls import_all with api_key' do
      allow(Fluro::Import::ApplicationService).to receive(:import_all)
      described_class.import_all('api_key')
      expect(Fluro::Import::ApplicationService).to have_received(:import_all).with('api_key')
    end
  end

  describe '#should_generate_new_friendly_id?' do
    it 'updates slug when title changes' do
      account.update(title: 'this is a test')
      expect(account.slug).to eq 'this-is-a-test'
    end
  end
end
