# frozen_string_literal: true

class CreateTeamMemberships < ActiveRecord::Migration[7.0]
  def change
    create_table :team_memberships, id: :uuid do |t|
      t.references :organization, null: false, foreign_key: { on_delete: :cascade }, type: :uuid
      t.references :contact, null: false, foreign_key: { on_delete: :cascade }, type: :uuid
      t.references :team, null: false, foreign_key: { on_delete: :cascade }, type: :uuid

      t.timestamps
    end
  end
end
