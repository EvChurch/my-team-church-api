# frozen_string_literal: true

class CreateRealmConnections < ActiveRecord::Migration[7.0]
  def change
    create_table :realm_connections, id: :uuid do |t|
      t.references :organization, null: false, foreign_key: { on_delete: :cascade }, type: :uuid
      t.references :subject, null: false, polymorphic: true, type: :uuid
      t.references :realm, null: false, foreign_key: { on_delete: :cascade }, type: :uuid

      t.timestamps
    end
    add_index :realm_connections,
              %i[subject_id subject_type realm_id],
              unique: true,
              name: 'index_realm_connections_on_subject_and_realm_id'
  end
end
