# frozen_string_literal: true

class PopulateTeamPositionAssignmentsCount < ActiveRecord::Migration[7.0]
  def up
    Team::Position.find_each do |position|
      Team::Position.reset_counters(position.id, :assignments)
    end
  end
end
