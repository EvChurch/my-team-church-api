# frozen_string_literal: true

class CreateObjectives < ActiveRecord::Migration[7.0]
  def change
    create_table :objectives, id: :uuid do |t|
      t.references :account, null: false, foreign_key: { on_delete: :cascade }, type: :uuid
      t.references :team, null: false, foreign_key: { on_delete: :cascade }, type: :uuid
      t.references :contact, null: false, foreign_key: { on_delete: :cascade }, type: :uuid
      t.string :title, null: false
      t.string :description
      t.string :status, null: false, default: 'draft'

      t.timestamps
    end
  end
end
