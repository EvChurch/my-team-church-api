# frozen_string_literal: true

class CreateTeamPositions < ActiveRecord::Migration[7.0]
  def change
    create_table :team_positions, id: :uuid do |t|
      t.references :account, null: false, foreign_key: { on_delete: :cascade }, type: :uuid
      t.references :team, null: false, foreign_key: { on_delete: :cascade }, type: :uuid
      t.string :slug, null: false
      t.string :title, null: false
      t.string :remote_id
      t.boolean :exclude, null: false, default: false
      t.boolean :reporter, null: false, default: false
      t.timestamps
    end
    add_index :team_positions, %i[account_id team_id slug], unique: true
    add_index :team_positions, %i[account_id team_id remote_id], unique: true
  end
end
