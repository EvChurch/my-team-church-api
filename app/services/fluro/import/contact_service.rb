# frozen_string_literal: true

module Fluro
  module Import
    class ContactService < Fluro::Import::BaseService
      def import
        @client.contacts.each do |remote_contact|
          import_contact(remote_contact)
        end
      end

      private

      def import_contact(remote_contact)
        contact = @organization.contacts.find_or_initialize_by(remote_id: remote_contact['_id'])
        contact.attributes(
          title: remote_contact['title'],
          first_name: remote_contact['firstName'],
          last_name: remote_contact['lastName'],
          emails: remote_contact['emails'],
          phone_numbers: remote_contact['phoneNumbers']
        )
        contact.realms = @organization.realms.where(remote_id: remote_contact['realms'].pluck('_id'))
      end
    end
  end
end
