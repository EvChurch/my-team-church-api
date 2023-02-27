# frozen_string_literal: true

module Fluro
  module Import
    class TeamService < Fluro::Import::BaseService
      protected

      def collection
        nested_hash = @client.teams.to_h { |e| [e['_id'], e.merge('children' => [])] }
        nested_hash.each do |_id, item|
          parent = nested_hash[item.dig('data', 'parentTeam')]
          parent['children'] << item if parent
        end
        nested_hash.select { |_id, item| item.dig('data', 'parentTeam').nil? }.values
      end

      def import_item(remote, parent = nil)
        team = @organization.teams.find_or_initialize_by(remote_id: remote['_id'])
        team.update attributes(remote).merge(parent:)
        connect_realms(remote, team)
        connect_contacts(remote, team)
        remote['children'].each do |remote_child|
          import_item(remote_child, team)
        end
      end

      private

      def attributes(remote)
        {
          definition: remote['definition'] || remote['_type'],
          slug: remote['slug'],
          status: remote['status'],
          title: remote['title']
        }
      end

      def connect_contacts(remote, team)
        team.contacts = @organization.contacts.where(remote_id: remote['provisionalMembers'].pluck('_id'))
      end
    end
  end
end
