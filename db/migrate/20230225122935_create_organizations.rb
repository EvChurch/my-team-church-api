# frozen_string_literal: true

class CreateOrganizations < ActiveRecord::Migration[7.0]
  def change
    create_table :organizations, id: :uuid do |t|
      t.string :title, null: false
      t.string :slug, null: false
      t.string :fluro_api_key

      t.timestamps
    end
    add_index :organizations, :slug, unique: true
  end
end
