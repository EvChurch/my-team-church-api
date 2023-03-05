# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Fluro::Import::ApplicationService, vcr: 'fluro/import/application_service' do
  subject(:application_service) { described_class.new(api_key) }

  let(:account) { create(:account, remote_id: '5c05049048890574c5395ca5') }
  let(:api_key) { 'fluro_api_key' }

  describe '#import_all' do
    let(:attributes) do
      {
        'definition' => 'application',
        'account_id' => account.id,
        'remote_id' => '63fbd5525a6b6b002498273e',
        'slug' => 'my-team-development',
        'status' => 'active',
        'title' => 'My Team (Development)',
        'api_key' => '<BEARER_TOKEN>',
        'created_at' => '2023-02-26 21:55:30.864000000 +0000'.to_time,
        'updated_at' => '2023-02-26 21:58:07.626000000 +0000'.to_time
      }
    end
    let(:account_attributes) do
      {
        'remote_id' => '5c05049048890574c5395ca5',
        'slug' => 'auckland-ev',
        'status' => 'active',
        'title' => 'Auckland Ev',
        'created_at' => '2018-12-03 10:25:20.416000000 +0000'.to_time,
        'updated_at' => '2022-10-14 21:10:34.749000000 +0000'.to_time
      }
    end

    it 'imports application' do
      application_service.import_all
      expect(Application.find_by(remote_id: attributes['remote_id']).attributes).to include(attributes)
    end

    it 'updates account' do
      application_service.import_all
      account.reload
      expect(account.attributes).to include(account_attributes)
    end
  end
end
