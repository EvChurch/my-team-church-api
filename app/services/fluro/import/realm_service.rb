# frozen_string_literal: true

module Fluro
  module Import
    class RealmService < Fluro::Import::BaseService
      protected

      def collection
        nested_hash = @client.realms.to_h { |e| [e['_id'], e.merge('children' => [])] }
        nested_hash.each do |_id, item|
          parent = nested_hash[item.dig('trail', -1, '_id')]
          parent['children'] << item if parent
        end
        nested_hash.select { |_id, item| item.dig('trail', -1, '_id').nil? }.values
      end

      def import_item(remote, parent = nil)
        realm = @organization.realms.find_or_initialize_by(remote_id: remote['_id'])
        realm.update attributes(remote).merge(parent:)
        remote['children'].each do |remote_child|
          import_item(remote_child, realm)
        end
      end

      private

      def attributes(remote)
        {
          definition: remote['definition'] || remote['_type'],
          slug: remote['slug'],
          status: remote['status'],
          title: remote['title'],
          bg_color: remote['bgColor'],
          color: remote['color']
        }
      end
    end
  end
end
