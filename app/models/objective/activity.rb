# frozen_string_literal: true

class Objective
  class Activity < ApplicationRecord
    multi_tenant :account
    belongs_to :objective
    belongs_to :result, optional: true
    belongs_to :contact
    enum progress: Objective.progresses
    after_commit :update_result, on: :create, if: :result
    enum kind: { progress_update: 'progress_update', note: 'note' }

    protected

    def update_result
      attributes = { progress:, current_value: }.compact

      result.update(attributes) if hash.present?
    end
  end
end
