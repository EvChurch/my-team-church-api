# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Fluro::Import::ContactService, :vcr do
  subject(:contact_service) { described_class.new(organization) }

  let(:organization) { create(:organization, fluro_api_key: 'fluro_api_key') }

  describe '#import' do
    describe 'with definition' do
      let(:attributes) do
        {
          'definition' => 'leader',
          'organization_id' => organization.id,
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
    end

    describe 'without definition' do
      let(:attributes) do
        {
          'definition' => 'contact',
          'organization_id' => organization.id,
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
    end
  end
end
