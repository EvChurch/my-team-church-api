# frozen_string_literal: true

class AddRequiredAssignmentsCountToTeamPositions < ActiveRecord::Migration[7.0]
  def change
    add_column :team_positions, :required_assignments_count, :integer, default: 0, null: false
  end
end
