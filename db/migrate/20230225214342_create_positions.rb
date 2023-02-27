# frozen_string_literal: true

class CreatePositions < ActiveRecord::Migration[7.0]
  def change
    create_table :positions, id: :uuid do |t|
      t.references :organization, foreign_key: { on_delete: :cascade }, type: :uuid
      t.string :ancestry, collation: :default
      t.string :title, null: false
      t.string :slug, null: false
      t.string :remote_id

      t.timestamps
    end
    add_index :positions, :ancestry
    add_index :positions, :remote_id
    add_index :positions, %i[organization_id slug], unique: true
  end
end
