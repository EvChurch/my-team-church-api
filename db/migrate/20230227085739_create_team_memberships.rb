# frozen_string_literal: true

class CreateTeamMemberships < ActiveRecord::Migration[7.0]
  def change
    create_table :team_memberships, id: :uuid do |t|
      t.references :account, null: false, foreign_key: { on_delete: :cascade }, type: :uuid
      t.references :contact, null: false, foreign_key: { on_delete: :cascade }, type: :uuid
      t.references :team, null: false, foreign_key: { on_delete: :cascade }, type: :uuid

      t.timestamps
    end
    add_index :team_memberships, %i[contact_id team_id], unique: true
  end
end
