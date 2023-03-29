# frozen_string_literal: true

class AddVisibleMembersToTeams < ActiveRecord::Migration[7.0]
  def change
    add_column :teams, :visible_members, :boolean
  end
end
