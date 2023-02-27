# frozen_string_literal: true

module Fluro
  module Import
    class RealmService < Fluro::Import::BaseService
      def import
        @client.realms.each do |remote_realm|
          import_realm(remote_realm)
        end
      end

      private

      def import_realm(remote_realm, parent = nil)
        realm = @organization.realms.find_or_initialize_by(remote_id: remote_realm['_id'])
        realm.update(
          title: remote_realm['title'],
          bg_color: remote_realm['bgColor'],
          color: remote_realm['color'],
          parent:
        )
        remote_realm['children'].each do |remote_child|
          import_realm(remote_child, realm)
        end
      end
    end
  end
end
