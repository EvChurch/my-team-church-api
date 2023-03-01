# frozen_string_literal: true

module Fluro
  module Import
    class RealmService < Fluro::Import::BaseService
      protected

      def remote_collection
        nested_hash = @client.realms.to_h { |e| [e['_id'], e.merge('children' => [])] }
        nested_hash.each do |_id, item|
          parent = nested_hash[item.dig('trail', -1, '_id')]
          parent['children'] << item if parent
        end
        nested_hash.select { |_id, item| item.dig('trail', -1, '_id').nil? }.values
      end

      def local_collection
        @account.realms
      end

      def remote_fields
        %w[status title bg_color color]
      end
    end
  end
end
