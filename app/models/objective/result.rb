# frozen_string_literal: true

class Objective
  class Result < ApplicationRecord
    multi_tenant :account
    belongs_to :objective
    belongs_to :contact
    has_many :progresses, dependent: :delete_all
    enum measurement: { numerical: 'numerical', percentage: 'percentage' }
    enum kind: { key_result: 'key_result', initiative: 'initiative' }
    enum progress: {
      no_status: 'no_status',
      off_track: 'off_track',
      needs_attention: 'needs_attention',
      on_track: 'on_track',
      accomplished: 'accomplished'
    }
    enum status: { active: 'active', archived: 'archived', draft: 'draft' }
    validates :title, :measurement, :kind, :progress, :start_value, :current_value, :target_value, :status,
              presence: true
  end
end
