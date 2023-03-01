# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Fluro::Import::ContactService, vcr: 'fluro/import/contact_service' do
  subject(:contact_service) { described_class.new(account) }

  let(:account) { create(:account, fluro_api_key: 'fluro_api_key') }

  describe '#import' do
    let!(:realm1) { create(:realm, account:, remote_id: '5c0d9d3e7ef61e100ae4514b') }
    let!(:realm2) { create(:realm, account:, remote_id: '5c0d9d497ef61e100ae45153') }

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
          'created_at' => '2014-01-15 01:36:47.000000000 +0000'.to_time,
          'updated_at' => '2023-02-21 22:21:19.559000000 +0000'.to_time
        }
      end
      let(:contact) { Contact.find_by(remote_id: '5c05057c48890574c5395cc6') }

      it 'imports contact' do
        contact_service.import
        expect(contact.attributes).to include(attributes)
      end

      it 'connects contact to realms' do
        contact_service.import
        expect(contact.realms).to match([realm1, realm2])
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
          'created_at' => '2014-01-15 01:36:47.000000000 +0000'.to_time,
          'updated_at' => '2023-02-21 22:21:19.559000000 +0000'.to_time
        }
      end
      let(:contact) { Contact.find_by(remote_id: '607bf8ccd6fc8e05f37379ed') }

      it 'imports contact' do
        contact_service.import
        expect(contact.attributes).to include(attributes)
      end

      it 'connects contact to realms' do
        contact_service.import
        expect(contact.realms).to match([realm1, realm2])
      end
    end
  end
end
