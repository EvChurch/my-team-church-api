# frozen_string_literal: true

class AddAssignmentsCountToTeamPositions < ActiveRecord::Migration[7.0]
  def change
    add_column :team_positions, :assignments_count, :integer, default: 0, null: false
  end
end
