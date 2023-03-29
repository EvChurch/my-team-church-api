# frozen_string_literal: true

class Contact < ApplicationRecord
  extend FriendlyId
  friendly_id :title, use: :scoped, scope: [:account_id]
  multi_tenant :account
  has_many :realm_connections,
           dependent: :delete_all,
           class_name: 'Realm::Connection',
           as: :subject
  has_many :realms, through: :realm_connections
  has_many :memberships,
           dependent: :delete_all,
           class_name: 'Team::Membership'
  has_many :teams, -> { where(visible_members: true) }, through: :memberships
  enum status: { active: 'active', archived: 'archived', draft: 'draft' }
  validates :title, :definition, presence: true
  validates :remote_id, uniqueness: { scope: :account_id }, allow_nil: true

  def should_generate_new_friendly_id?
    title_changed?
  end
end
