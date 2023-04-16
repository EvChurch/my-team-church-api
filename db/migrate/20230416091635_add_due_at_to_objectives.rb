class AddDueAtToObjectives < ActiveRecord::Migration[7.0]
  def change
    add_column :objectives, :due_at, :date, null: false
  end
end
