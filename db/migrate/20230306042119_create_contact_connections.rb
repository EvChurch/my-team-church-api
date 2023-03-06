# frozen_string_literal: true

class CreateContactConnections < ActiveRecord::Migration[7.0]
  def change
    create_table :contact_connections, id: :uuid do |t|
      t.references :account, null: false, foreign_key: { on_delete: :cascade }, type: :uuid
      t.references :contact, null: false, foreign_key: { on_delete: :cascade }, type: :uuid
      t.references :user, null: false, foreign_key: { on_delete: :cascade }, type: :uuid

      t.timestamps
    end
    add_index :contact_connections, %i[user_id contact_id], unique: true
  end
end
