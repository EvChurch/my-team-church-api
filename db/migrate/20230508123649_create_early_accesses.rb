# frozen_string_literal: true

class CreateEarlyAccesses < ActiveRecord::Migration[7.0]
  def change
    create_table :early_accesses, id: :uuid do |t|
      t.string :first_name, null: false
      t.string :email_address, null: false

      t.timestamps
    end

    add_index :early_accesses, :email_address, unique: true
  end
end
