# frozen_string_literal: true

class CreateTeamAssignments < ActiveRecord::Migration[7.0]
  def change
    create_table :team_assignments, id: :uuid do |t|
      t.references :account, null: false, foreign_key: { on_delete: :cascade }, type: :uuid
      t.references :position, null: false, foreign_key: { on_delete: :cascade, to_table: :team_positions }, type: :uuid
      t.references :contact, null: false, foreign_key: { on_delete: :cascade }, type: :uuid

      t.timestamps
    end

    add_index :team_assignments, %i[position_id contact_id], unique: true
  end
end
