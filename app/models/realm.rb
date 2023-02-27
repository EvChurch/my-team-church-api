# frozen_string_literal: true

class Realm < ApplicationRecord
  extend FriendlyId
  friendly_id :title, use: :scoped, scope: [:organization_id]
  has_ancestry primary_key_format: %r{\A[\w-]+(/[\w-]+)*\z}
  multi_tenant :organization
  has_many :connections,
           dependent: :delete_all,
           class_name: 'Realm::Connection'
  has_many :contacts, through: :connections, source: :subject, source_type: 'Contact'
  has_many :teams, through: :connections, source: :subject, source_type: 'Team'
  enum status: { active: 'active', archived: 'archived' }
  validates :title, presence: true
end
