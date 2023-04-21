# frozen_string_literal: true

class CreateObjectiveActivities < ActiveRecord::Migration[7.0]
  def change
    create_table :objective_activities, id: :uuid do |t|
      t.belongs_to :account, null: false, foreign_key: { on_delete: :cascade }, type: :uuid
      t.belongs_to :objective, null: false, foreign_key: { on_delete: :cascade }, type: :uuid
      t.belongs_to :result, foreign_key: { on_delete: :cascade, to_table: :objective_results }, type: :uuid
      t.belongs_to :contact, null: false, foreign_key: { on_delete: :cascade }, type: :uuid
      t.string :kind, null: false, default: 'progress_update'
      t.decimal :current_value
      t.string :progress
      t.string :comment

      t.timestamps
    end
  end
end
