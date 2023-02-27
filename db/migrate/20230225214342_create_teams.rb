# frozen_string_literal: true

class CreateTeams < ActiveRecord::Migration[7.0]
  def change
    create_table :teams, id: :uuid do |t|
      t.references :organization, null: false, foreign_key: { on_delete: :cascade }, type: :uuid
      t.string :ancestry, collation: :default
      t.string :definition, null: false
      t.string :slug, null: false
      t.string :status, default: 'active'
      t.string :title, null: false
      t.string :remote_id

      t.timestamps
    end
    add_index :teams, :ancestry
    add_index :teams, :remote_id
    add_index :teams, %i[organization_id slug], unique: true
  end
end
