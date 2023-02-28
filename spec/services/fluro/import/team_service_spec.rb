# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Fluro::Import::TeamService, vcr: 'fluro/import/team_service' do
  subject(:team_service) { described_class.new(organization) }

  let(:organization) { create(:organization, fluro_api_key: 'fluro_api_key') }

  describe '#import' do
    let(:team) { Team.find_by(remote_id: '5c0dd66be6f97b5fa6211998') }

    describe 'parent' do
      let(:attributes) do
        {
          'ancestry' => nil,
          'created_at' => '2021-01-02 03:24:52.840000000 +0000'.to_time,
          'definition' => 'team',
          'organization_id' => organization.id,
          'remote_id' => '5c0dd66be6f97b5fa6211998',
          'slug' => 'the-parent-team',
          'status' => 'active',
          'title' => 'The Parent Team',
          'updated_at' => '2021-04-23 22:20:38.284000000 +0000'.to_time
        }
      end

      it 'imports parent team' do
        team_service.import
        expect(team.attributes).to include(attributes)
      end
    end

    describe 'child' do
      let(:child_attributes) do
        {
          'ancestry' => team.id,
          'created_at' => '2021-01-02 03:24:52.840000000 +0000'.to_time,
          'definition' => 'serviceTeam',
          'organization_id' => organization.id,
          'remote_id' => '5c05050b48890574c5395cad',
          'slug' => 'the-child-team',
          'status' => 'active',
          'title' => 'The Child Team',
          'updated_at' => '2021-04-23 22:20:38.284000000 +0000'.to_time
        }
      end
      let(:child) { Team.find_by(remote_id: '5c05050b48890574c5395cad') }

      it 'imports child team' do
        team_service.import
        expect(child.attributes).to include(child_attributes)
      end
    end

    describe 'realms association' do
      let!(:realm1) { create(:realm, organization:, remote_id: '5c0d9d3e7ef61e100ae4514b') }
      let!(:realm2) { create(:realm, organization:, remote_id: '5c0d9d497ef61e100ae45153') }

      it 'connects team to realms' do
        team_service.import
        expect(team.realm_ids).to match([realm1.id, realm2.id])
      end
    end

    describe 'contacts association' do
      let!(:contact1) { create(:contact, organization:, remote_id: '5c0d98ef44d30a36d8c5574d') }
      let!(:contact2) { create(:contact, organization:, remote_id: '5c05049048890574c5395ca5') }

      it 'connects team to contacts' do
        team_service.import
        expect(team.contact_ids).to match([contact1.id, contact2.id])
      end
    end
  end
end