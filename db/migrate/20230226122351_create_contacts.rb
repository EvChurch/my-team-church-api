# frozen_string_literal: true

class CreateContacts < ActiveRecord::Migration[7.0]
  def change
    create_table :contacts, id: :uuid do |t|
      t.references :organization, foreign_key: { on_delete: :cascade }, type: :uuid
      t.string :title, null: false
      t.string :slug, null: false
      t.string :first_name
      t.string :last_name
      t.text :emails, array: true, default: []
      t.text :phone_numbers, array: true, default: []
      t.string :remote_id

      t.timestamps
    end
    add_index :contacts, :remote_id
    add_index :contacts, %i[organization_id slug], unique: true
  end
end
