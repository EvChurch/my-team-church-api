# frozen_string_literal: true

class CreateAccounts < ActiveRecord::Migration[7.0]
  def change
    create_table :accounts, id: :uuid do |t|
      t.string :title, null: false
      t.string :slug, null: false
      t.string :fluro_api_key

      t.timestamps
    end
    add_index :accounts, :slug, unique: true
  end
end
