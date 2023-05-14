# frozen_string_literal: true

class AddProgressToAssignments < ActiveRecord::Migration[7.0]
  def change
    add_column :team_assignments, :progress, :string, null: false, default: 'no_status'
    add_index :team_assignments, :progress
    add_column :team_positions, :progress, :string, null: false, default: 'no_status'
    add_index :team_positions, :progress
  end
end
