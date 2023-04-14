# frozen_string_literal: true

class CreateObjectives < ActiveRecord::Migration[7.0]
  def change
    create_table :objectives, id: :uuid do |t|
      t.references :account, null: false, foreign_key: { on_delete: :cascade }, type: :uuid
      t.uuid :objectable_id, null: false
      t.string :objectable_type, null: false
      t.string :title, null: false
      t.string :description
      t.string :status, null: false, default: 'draft'

      t.timestamps
    end

    add_index :objectives, %i[objectable_id objectable_type]
  end
end
