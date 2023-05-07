# frozen_string_literal: true

class Objective < ApplicationRecord
  multi_tenant :account
  belongs_to :team
  belongs_to :contact
  has_many :results, dependent: :delete_all
  has_many :activities, dependent: :delete_all
  enum progress: {
    no_status: 'no_status',
    off_track: 'off_track',
    needs_attention: 'needs_attention',
    on_track: 'on_track',
    accomplished: 'accomplished'
  }
  enum status: { active: 'active', archived: 'archived', draft: 'draft' }
  validates :title, presence: true
  validate :contact_is_member_of_team
  before_save :update_summary
  after_commit :update_team_summary

  protected

  def update_team_summary
    if saved_change_to_attribute?(:percentage) ||
       saved_change_to_attribute?(:progress)
      team.save
    end
  end

  def contact_is_member_of_team
    return unless team.present? && contact.present?

    return if team.contacts.include?(contact)

    errors.add(:contact_id, 'contact must be member of team')
  end

  def update_summary
    key_results = results.key_result.to_a
    update_percentage(key_results)
    update_progress(key_results)
  end

  def update_percentage(key_results)
    self.percentage = if key_results.empty?
                        0
                      else
                        key_results.sum(&:percentage) / key_results.size
                      end
  end

  def update_progress(key_results)
    self.progress = key_results.pluck(:progress)
                               .reject { |v| v == Objective.progresses[:no_status] }
                               .min_by { |v| Objective.progresses.values.find_index(v) } ||
                    Objective.progresses[:no_status]
  end
end
