# frozen_string_literal: true

class Objective
  class Activity < ApplicationRecord
    multi_tenant :account
    belongs_to :objective
    belongs_to :result, optional: true
    belongs_to :contact
    enum progress: Objective.progresses
    enum kind: { progress_update: 'progress_update', note: 'note' }
    validate :contact_is_member_of_team
    validates :result, presence: true, if: :result_id
    validate :result_belongs_to_objective, if: :result
    after_commit :update_result, on: :create, if: :result

    protected

    def contact_is_member_of_team
      return unless objective.present? && contact.present?

      return if objective.team.contacts.include?(contact)

      errors.add(:contact_id, 'contact must be member of team')
    end

    def result_belongs_to_objective
      return unless objective.present? && result.present?

      return if objective.id == result.objective_id

      errors.add(:result_id, 'result must belong to objective')
    end

    def update_result
      attributes = { progress:, current_value: }.compact

      result.update(attributes) if hash.present?
    end
  end
end
