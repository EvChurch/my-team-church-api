# frozen_string_literal: true

module Fluro
  module Import
    class ApplicationService < Fluro::Import::BaseService
      def initialize(api_key)
        super
        @account = import_account(client.account(remote_collection.first.dig('account', '_id')))
      end

      def remote_collection
        @remote_collection ||= [client.session]
      end

      def local_collection
        account.application
      end

      def import(remote, parent = nil)
        local = account.application
        local ||= account.build_application(remote_id: remote['_id'])
        local.update! attributes(remote, parent)
        connect_realms(remote, local)
        connect_associations(remote, local)
      end

      protected

      def remote_fields
        %w[api_key]
      end

      def transform_key_map
        { 'apikey' => 'api_key' }
      end

      def import_account(remote)
        local = Account.find_or_initialize_by(remote_id: remote['_id'])
        local.update!(
          'status' => remote['status'],
          'title' => remote['title'],
          'created_at' => remote['created'],
          'updated_at' => remote['updated']
        )
        local
      end

      def account_attributes(remote)
        {
          'status' => remote['status'],
          'title' => remote['title'],
          'created_at' => remote['created'],
          'updated_at' => remote['updated']
        }
      end
    end
  end
end
