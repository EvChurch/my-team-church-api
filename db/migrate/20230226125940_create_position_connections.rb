# frozen_string_literal: true

class CreatePositionConnections < ActiveRecord::Migration[7.0]
  def change
    create_table :position_connections, id: :uuid do |t|
      t.references :organization, foreign_key: { on_delete: :cascade }, type: :uuid
      t.references :realm, foreign_key: { on_delete: :cascade }, type: :uuid
      t.references :position, foreign_key: { on_delete: :cascade }, type: :uuid

      t.timestamps
    end
    add_index :position_connections, %i[position_id realm_id], unique: true
  end
end
