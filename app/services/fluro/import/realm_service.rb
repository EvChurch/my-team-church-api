# frozen_string_literal: true

module Fluro
  module Import
    class RealmService < Fluro::Import::BaseService
      protected

      def collection
        @client.realms
      end

      def import_item(remote, parent = nil)
        realm = @organization.realms.find_or_initialize_by(remote_id: remote['_id'])
        realm.update(
          title: remote['title'],
          bg_color: remote['bgColor'],
          color: remote['color'],
          parent:
        )
        remote['children'].each do |remote_child|
          import_item(remote_child, realm)
        end
      end
    end
  end
end
