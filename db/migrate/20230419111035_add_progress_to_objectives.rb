class AddProgressToObjectives < ActiveRecord::Migration[7.0]
  def change
    add_column :objectives, :progress, :string, null: false, default: 'no_status'
  end
end
