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
        %w[status title first_name last_name emails phone_numbers]
      end
    end
  end
end
