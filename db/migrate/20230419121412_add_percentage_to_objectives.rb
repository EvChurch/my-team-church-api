# frozen_string_literal: true

class AddPercentageToObjectives < ActiveRecord::Migration[7.0]
  def change
    add_column :objectives, :percentage, :decimal, null: false, default: 0
  end
end
