# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Fluro::Import::ContactService,
               vcr: { cassette_name: 'fluro/import/contact_service', record: :new_episodes } do
  subject(:contact_service) { described_class.new(application) }

  let(:account) { create(:account) }
  let(:application) { create(:application, api_key: 'fluro_api_key') }

  describe '#import_all' do
    let!(:realm1) { create(:realm, remote_id: '5c0d9d3e7ef61e100ae4514b') }
    let!(:realm2) { create(:realm, remote_id: '5c0d9d497ef61e100ae45153') }

    describe 'with definition' do
      let(:attributes) do
        {
          'definition' => 'leader',
          'account_id' => account.id,
          'remote_id' => '5c05057c48890574c5395cc6',
          'slug' => 'robert-smith',
          'status' => 'active',
          'title' => 'Robert Smith',
          'first_name' => 'Robert',
          'last_name' => 'Smith',
          'emails' => ['robert@aucklandev.co.nz', 'robert.smith@gmail.com'],
          'phone_numbers' => %w[021098765 6421098765],
          'avatar' => 'YXZhdGFy',
          'created_at' => '2014-01-15 01:36:47.000000000 +0000'.to_time,
          'updated_at' => '2023-02-21 22:21:19.559000000 +0000'.to_time
        }
      end

      it 'imports contact' do
        contact_service.import_all
        expect(Contact.find_by(remote_id: attributes['remote_id']).attributes).to include(attributes)
      end

      it 'connects contact to realms' do
        contact_service.import_all
        expect(Contact.find_by(remote_id: attributes['remote_id']).realm_ids).to match([realm1.id, realm2.id])
      end
    end

    describe 'without definition' do
      let(:attributes) do
        {
          'definition' => 'contact',
          'account_id' => account.id,
          'remote_id' => '607bf8ccd6fc8e05f37379ed',
          'slug' => 'michelle-smith',
          'status' => 'active',
          'title' => 'Michelle Smith',
          'first_name' => 'Michelle',
          'last_name' => 'Smith',
          'emails' => ['michelle@aucklandev.co.nz', 'michelle.smith@gmail.com'],
          'phone_numbers' => %w[021098761 6421098761],
          'avatar' => 'YXZhdGFy',
          'created_at' => '2014-01-15 01:36:47.000000000 +0000'.to_time,
          'updated_at' => '2023-02-21 22:21:19.559000000 +0000'.to_time
        }
      end

      it 'imports contact' do
        contact_service.import_all
        expect(Contact.find_by(remote_id: attributes['remote_id']).attributes).to include(attributes)
      end

      it 'connects contact to realms' do
        contact_service.import_all
        expect(Contact.find_by(remote_id: attributes['remote_id']).realm_ids).to match([realm1.id, realm2.id])
      end
    end
  end
end
