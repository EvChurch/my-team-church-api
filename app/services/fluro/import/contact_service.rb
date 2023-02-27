# frozen_string_literal: true

module Fluro
  module Import
    class ContactService < Fluro::Import::BaseService
      protected

      def collection
        @client.contacts
      end

      def import_item(remote)
        contact = @organization.contacts.find_or_initialize_by(remote_id: remote['_id'])
        contact.update attributes(remote)
        connect_realms(remote, contact)
      end

      private

      def attributes(remote)
        {
          definition: remote['definition'] || remote['_type'],
          slug: remote['slug'],
          status: remote['status'],
          title: remote['title'],
          first_name: remote['firstName'],
          last_name: remote['lastName'],
          emails: remote['emails'],
          phone_numbers: remote['phoneNumbers']
        }
      end
    end
  end
end
