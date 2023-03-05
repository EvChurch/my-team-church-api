# frozen_string_literal: true

module Fluro
  module Import
    class BaseService
      attr_reader :account, :client

      def initialize(application)
        @account = application.account unless application.is_a?(String)
        @client ||= Fluro::ClientService.new(application.is_a?(String) ? application : application.api_key)
      end

      def self.import_all(application)
        new(application).import_all
      end

      def import_all
        remote_collection.each do |remote_item|
          import(remote_item)
        end
      end

      def import(remote, parent = nil)
        local = local_collection.find_or_initialize_by(remote_id: remote['_id'])
        local.update! attributes(remote, parent)
        connect_realms(remote, local) unless local_collection.klass == Realm
        connect_associations(remote, local)
        remote['children']&.each do |remote_child|
          import(remote_child, local)
        end
      end

      protected

      def connect_realms(remote, local)
        local.realms = account.realms.where(remote_id: remote['realms'].pluck('_id'))
      end

      def attributes(remote, parent)
        attributes = remote.transform_keys(&method(:transform)).slice(*(remote_fields + %w[status title]))
        attributes['created_at'] = remote['created']
        attributes['updated_at'] = remote['updated']
        attributes['definition'] = remote['definition'] || remote['_type']
        attributes['parent'] = parent unless parent.nil?
        attributes
      end

      def transform(key)
        transform_key_map[key] || key.underscore
      end

      def transform_key_map
        {}
      end

      def remote_fields
        []
      end

      def connect_associations(remote, local); end
    end
  end
end
