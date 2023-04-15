# frozen_string_literal: true

class Team < ApplicationRecord
  extend FriendlyId
  friendly_id :title, use: :scoped, scope: [:account_id]
  has_ancestry primary_key_format: %r{\A[\w-]+(/[\w-]+)*\z}
  multi_tenant :account
  has_many :realm_connections,
           dependent: :delete_all,
           class_name: 'Realm::Connection',
           as: :subject
  has_many :realms, through: :realm_connections
  has_many :memberships,
           dependent: :delete_all,
           class_name: 'Team::Membership'
  has_many :contacts, through: :memberships
  has_many :objectives, dependent: :delete_all
  enum status: { active: 'active', archived: 'archived', draft: 'draft' }
  validates :title, :definition, presence: true
  validates :remote_id, uniqueness: { scope: :account_id }, allow_nil: true

  def should_generate_new_friendly_id?
    title_changed?
  end
end
