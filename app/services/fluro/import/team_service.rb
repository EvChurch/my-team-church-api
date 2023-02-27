# frozen_string_literal: true

module Fluro
  module Import
    class TeamService < Fluro::Import::BaseService
      protected

      def collection
        @client.teams
      end

      def import_item(_remote_team)
        team = @organization.teams.find_or_initialize_by(remote_id: remote['_id'])
        team.update(
          title: remote['title'],
          bg_color: remote['bgColor'],
          color: remote['color'],
          parent:
        )
      end
    end
  end
end
