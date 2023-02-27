# frozen_string_literal: true

class Team < ApplicationRecord
  extend FriendlyId
  friendly_id :title, use: :scoped, scope: [:organization_id]
  has_ancestry primary_key_format: %r{\A[\w-]+(/[\w-]+)*\z}
  multi_tenant :organization
  has_many :realm_connections,
           dependent: :delete_all,
           class_name: 'Realm::Connection',
           as: :subject
  has_many :realms, through: :realm_connections
  has_many :memberships,
           dependent: :delete_all,
           class_name: 'Team::Membership'
  has_many :contacts, through: :memberships
  validates :title, presence: true
end
