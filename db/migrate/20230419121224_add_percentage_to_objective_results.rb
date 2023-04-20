# frozen_string_literal: true

class AddPercentageToObjectiveResults < ActiveRecord::Migration[7.0]
  def change
    add_column :objective_results, :percentage, :integer, null: false, default: 0
  end
end
