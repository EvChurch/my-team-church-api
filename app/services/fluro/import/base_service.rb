# frozen_string_literal: true

module Fluro
  module Import
    class BaseService
      attr_reader :account, :client

      def initialize(application)
        @account = application.account
        @client = Fluro::ClientService.new(application)
      end

      def self.import_all(application)
        new(application).import
      end

      def import_all
        remote_collection.each do |remote_item|
          import_item(remote_item)
        end
      end

      protected

      def import_item(remote, parent = nil)
        local = local_collection.find_or_initialize_by(remote_id: remote['_id'])
        local.update! attributes(remote, parent)
        connect_realms(remote, local) unless local_collection.klass == Realm
        connect_associations(remote, local)
        remote['children']&.each do |remote_child|
          import_item(remote_child, local)
        end
      end

      def connect_realms(remote, local)
        local.realms = account.realms.where(remote_id: remote['realms'].pluck('_id'))
      end

      def attributes(remote, parent)
        attributes = remote.transform_keys(&:underscore).slice(*remote_fields)
        attributes['created_at'] = remote['created']
        attributes['updated_at'] = remote['updated']
        attributes['definition'] = remote['definition'] || remote['_type']
        attributes['parent'] = parent unless parent.nil?
        attributes
      end

      def remote_fields
        []
      end

      def connect_associations(remote, local); end
    end
  end
end
