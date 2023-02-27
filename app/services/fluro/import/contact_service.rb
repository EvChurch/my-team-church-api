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
        contact.update(
          title: remote['title'],
          first_name: remote['firstName'],
          last_name: remote['lastName'],
          emails: remote['emails'],
          phone_numbers: remote['phoneNumbers']
        )
        @organization.realms.where(remote_id: remote['realms'].pluck('_id')).each do |realm|
          contact.contact_connections.find_or_create_by(realm_id: realm.id)
        end
      end
    end
  end
end
