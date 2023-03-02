# frozen_string_literal: true

class CreateAccounts < ActiveRecord::Migration[7.0]
  def change
    create_table :accounts, id: :uuid do |t|
      t.string :slug, null: false
      t.string :status, default: 'active'
      t.string :title, null: false
      t.string :remote_id

      t.timestamps
    end
    add_index :accounts, :remote_id, unique: true
    add_index :accounts, :slug, unique: true
  end
end
