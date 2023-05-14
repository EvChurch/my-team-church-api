# frozen_string_literal: true

class Team
  class Assignment < ApplicationRecord
    multi_tenant :account
    belongs_to :position, counter_cache: true
    belongs_to :contact
    validates :position_id, uniqueness: { scope: %i[contact_id] }
    enum progress: Objective.progresses.except(:accomplished)
    after_commit :update_position_summary

    protected

    def update_position_summary
      position.save if saved_change_to_attribute?(:progress)
    end
  end
end
