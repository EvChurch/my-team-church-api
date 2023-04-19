# frozen_string_literal: true

class CreateObjectiveResults < ActiveRecord::Migration[7.0]
  def change
    create_table :objective_results, id: :uuid do |t|
      t.belongs_to :account, null: false, foreign_key: { on_delete: :cascade }, type: :uuid
      t.belongs_to :objective, null: false, foreign_key: { on_delete: :cascade }, type: :uuid
      t.string :title, null: false
      t.string :description
      t.belongs_to :contact, null: false, foreign_key: { on_delete: :cascade }, type: :uuid
      t.string :measurement, null: false, default: 'numerical'
      t.string :kind, null: false, default: 'key_result'
      t.string :progress, null: false, default: 'no_status'
      t.decimal :start_value, null: false, default: 0.0
      t.decimal :current_value, null: false, default: 0.0
      t.decimal :target_value, null: false, default: 100.0
      t.date :start_at
      t.date :due_at
      t.string :status, null: false, default: 'draft'

      t.timestamps
    end
  end
end
