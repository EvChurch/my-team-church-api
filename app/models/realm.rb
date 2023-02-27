# frozen_string_literal: true

class Realm < ApplicationRecord
  extend FriendlyId
  friendly_id :title, use: :scoped, scope: [:organization_id]
  has_ancestry primary_key_format: %r{\A[\w-]+(/[\w-]+)*\z}
  multi_tenant :organization
  has_many :contact_connections,
           dependent: :delete_all,
           class_name: 'Contact::Connection'
  has_many :contacts, through: :contact_connections
  has_many :position_connections,
           dependent: :delete_all,
           class_name: 'Position::Connection'
  has_many :positions, through: :position_connections
  validates :title, presence: true
end
