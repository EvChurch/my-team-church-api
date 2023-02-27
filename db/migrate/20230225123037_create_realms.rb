# frozen_string_literal: true

class CreateRealms < ActiveRecord::Migration[7.0]
  def change
    create_table :realms, id: :uuid do |t|
      t.references :organization, null: false, foreign_key: { on_delete: :cascade }, type: :uuid
      t.string :ancestry, collation: :default
      t.string :definition, null: false
      t.string :slug, null: false
      t.string :status, default: 'active'
      t.string :title, null: false
      t.string :remote_id
      t.string :color
      t.string :bg_color

      t.timestamps
    end
    add_index :realms, :ancestry
    add_index :realms, :remote_id
    add_index :realms, %i[organization_id slug], unique: true
  end
end
