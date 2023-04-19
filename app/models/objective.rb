# frozen_string_literal: true

class Objective < ApplicationRecord
  multi_tenant :account
  belongs_to :team
  belongs_to :contact
  has_many :results, dependent: :delete_all
  has_many :audits, through: :results, class_name: 'Objective::Result::Audit'
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

  protected

  def contact_is_member_of_team
    return unless team.present? && contact.present?

    return if team.contacts.include?(contact)

    errors.add(:contact_id, 'contact must be member of team')
  end
end
