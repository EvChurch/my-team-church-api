# frozen_string_literal: true

module Fluro
  module Import
    class TeamService < Fluro::Import::BaseService
      protected

      def remote_collection
        nested_hash = client.teams.to_h { |e| [e['_id'], e.merge('children' => [])] }
        nested_hash.each do |_id, item|
          parent = nested_hash[item.dig('data', 'parentTeam')]
          parent['children'] << item if parent
        end
        nested_hash.select { |_id, item| item.dig('data', 'parentTeam').nil? }.values
      end

      def local_collection
        account.teams
      end

      def connect_associations(remote, team)
        team.contacts = @account.contacts.where(remote_id: remote['provisionalMembers'].pluck('_id'))
        remote['assignments'].each do |position|
          create_or_update_position(position, team)
        end
      end

      def create_or_update_position(remote, team)
        position = team.positions.find_or_initialize_by(remote_id: remote['_id'])
        position.update!(
          title: remote['title'],
          exclude: remote['exclude'] || false,
          reporter: remote['reporter'] || false
        )
        position.contacts = @account.contacts.where(remote_id: remote['contacts'].pluck('_id'))
      end

      def remote_fields
        %w[visible_members]
      end
    end
  end
end
