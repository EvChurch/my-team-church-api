# frozen_string_literal: true

class Objective < ApplicationRecord
  multi_tenant :account
  belongs_to :team
  belongs_to :contact
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
