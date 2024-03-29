# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Fluro::Import::RealmService, vcr: 'fluro/import/realm_service' do
  subject(:realm_service) { described_class.new(application) }

  let(:account) { create(:account) }
  let(:application) { create(:application, api_key: 'fluro_api_key') }

  describe '#import_all' do
    let(:attributes) do
      {
        'ancestry' => nil,
        'bg_color' => '#555',
        'color' => '#eee',
        'created_at' => '2018-12-10 02:58:51.704000000 +0000'.to_time,
        'definition' => 'realm',
        'account_id' => account.id,
        'remote_id' => '5c0dd66be6f97b5fa6211998',
        'slug' => 'system',
        'status' => 'active',
        'title' => 'System',
        'updated_at' => '2018-12-10 02:58:51.708000000 +0000'.to_time
      }
    end
    let(:child_attributes) do
      {
        'ancestry' => realm.id,
        'bg_color' => '#555',
        'color' => '#eee',
        'created_at' => '2018-12-03 10:27:23.136000000 +0000'.to_time,
        'definition' => 'locationRealm',
        'account_id' => account.id,
        'remote_id' => '5c05050b48890574c5395cad',
        'slug' => 'church',
        'status' => 'active',
        'title' => 'Church',
        'updated_at' => '2021-04-21 05:10:44.668000000 +0000'.to_time
      }
    end
    let(:realm) { Realm.find_by(remote_id: attributes['remote_id']) }

    it 'imports system realm' do
      realm_service.import_all
      expect(realm.attributes).to include(attributes)
    end

    it 'imports church realm' do
      realm_service.import_all
      expect(Realm.find_by(remote_id: child_attributes['remote_id']).attributes).to include(child_attributes)
    end
  end
end
