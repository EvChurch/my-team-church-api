# frozen_string_literal: true

module Fluro
  module Import
    class ContactService < Fluro::Import::BaseService
      protected

      def remote_collection
        client.contacts
      end

      def local_collection
        account.contacts
      end

      def remote_fields
        %w[first_name last_name emails phone_numbers]
      end

      def attributes(remote, parent)
        attributes = super

        attributes['avatar'] = client.avatar('contact', remote['_id'])
        attributes
      end
    end
  end
end
