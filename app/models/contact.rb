# frozen_string_literal: true

class Contact < ApplicationRecord
  extend FriendlyId
  friendly_id :title, use: :scoped, scope: [:organization_id]
  multi_tenant :organization
  has_many :realm_connections,
           dependent: :delete_all,
           class_name: 'Realm::Connection',
           as: :subject
  has_many :realms, through: :realm_connections
  has_many :memberships,
           dependent: :delete_all,
           class_name: 'Team::Membership'
  has_many :teams, through: :memberships
  enum status: { active: 'active', archived: 'archived', draft: 'draft' }
  validates :title, :definition, presence: true
end
