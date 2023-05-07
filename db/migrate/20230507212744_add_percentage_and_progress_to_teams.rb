# frozen_string_literal: true

class AddPercentageAndProgressToTeams < ActiveRecord::Migration[7.0]
  def change
    change_table :teams, bulk: true do |t|
      t.integer :percentage, null: false, default: 0
      t.string :progress, null: false, default: 'no_status'
    end
  end
end
