class AddAvatarToContacts < ActiveRecord::Migration[7.0]
  def change
    add_column :contacts, :avatar, :string
  end
end
