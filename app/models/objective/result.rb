# frozen_string_literal: true

class Objective
  class Result < ApplicationRecord
    multi_tenant :account
    belongs_to :objective
    belongs_to :contact
    has_many :audits, dependent: :delete_all
    enum measurement: { numerical: 'numerical', percentage: 'percentage', currency: 'currency' }
    enum kind: { key_result: 'key_result', initiative: 'initiative' }
    enum progress: Objective.progresses
    enum status: { active: 'active', archived: 'archived', draft: 'draft' }
    validates :title, :measurement, :kind, :progress, :start_value, :target_value, :status,
              presence: true
    validate :start_value_must_not_equal_target_value
    validate :contact_is_member_of_team
    before_save :update_percentage
    after_commit :update_objective_summary

    protected

    def contact_is_member_of_team
      return unless objective.present? && contact.present?

      return if objective.team.contacts.include?(contact)

      errors.add(:contact_id, 'contact must be member of team')
    end

    def start_value_must_not_equal_target_value
      return unless start_value == target_value

      errors.add(:start_value, 'must not equal target value')
    end

    def update_percentage
      diff = (start_value - target_value).abs
      current = ((current_value || start_value) - start_value).abs
      self.percentage = (current / diff) * 100
    end

    def update_objective_summary
      if saved_change_to_attribute?(:percentage) ||
         saved_change_to_attribute?(:kind) ||
         saved_change_to_attribute?(:progress)
        objective.save
      end
    end
  end
end
