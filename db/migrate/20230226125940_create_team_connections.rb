# frozen_string_literal: true

class CreateTeamConnections < ActiveRecord::Migration[7.0]
  def change
    create_table :team_connections, id: :uuid do |t|
      t.references :organization, foreign_key: { on_delete: :cascade }, type: :uuid
      t.references :realm, foreign_key: { on_delete: :cascade }, type: :uuid
      t.references :team, foreign_key: { on_delete: :cascade }, type: :uuid

      t.timestamps
    end
    add_index :team_connections, %i[team_id realm_id], unique: true
  end
end
