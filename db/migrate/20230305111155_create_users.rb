# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users, id: :uuid do |t|
      t.references :account, null: false, foreign_key: { on_delete: :cascade }, type: :uuid
      t.string :title, null: false
      t.string :slug, null: false
      t.string :remote_id
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :phone_number

      t.timestamps
    end
    add_index :users, %i[account_id remote_id], unique: true
    add_index :users, %i[account_id slug], unique: true
  end
end
