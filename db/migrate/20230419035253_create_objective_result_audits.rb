# frozen_string_literal: true

class CreateObjectiveResultAudits < ActiveRecord::Migration[7.0]
  def change
    create_table :objective_result_audits, id: :uuid do |t|
      t.belongs_to :account, null: false, foreign_key: { on_delete: :cascade }, type: :uuid
      t.belongs_to :result, null: false, foreign_key: { on_delete: :cascade, to_table: :objective_results }, type: :uuid
      t.belongs_to :contact, null: false, foreign_key: { on_delete: :cascade }, type: :uuid
      t.decimal :current_value, null: true
      t.string :progress, null: true
      t.string :comment

      t.timestamps
    end
  end
end
