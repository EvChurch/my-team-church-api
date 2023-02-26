# frozen_string_literal: true

class CreateContactConnections < ActiveRecord::Migration[7.0]
  def change
    create_table :contact_connections, id: :uuid do |t|
      t.references :organization, foreign_key: { on_delete: :cascade }, type: :uuid
      t.references :realm, foreign_key: { on_delete: :cascade }, type: :uuid
      t.references :contact, foreign_key: { on_delete: :cascade }, type: :uuid

      t.timestamps
    end
    add_index :contact_connections, %i[realm_id contact_id], unique: true
  end
end
