# frozen_string_literal: true

class CreateContactMemberships < ActiveRecord::Migration[7.0]
  def change
    create_table :contact_memberships, id: :uuid do |t|
      t.references :organization, foreign_key: { on_delete: :cascade }, type: :uuid
      t.references :position, foreign_key: { on_delete: :cascade }, type: :uuid
      t.references :contact, foreign_key: { on_delete: :cascade }, type: :uuid

      t.timestamps
    end
    add_index :contact_memberships, %i[position_id contact_id], unique: true
  end
end
