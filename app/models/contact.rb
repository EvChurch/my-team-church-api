# frozen_string_literal: true

class Contact < ApplicationRecord
  extend FriendlyId
  friendly_id :title, use: :scoped, scope: [:organization_id]
  multi_tenant :organization
  has_many :contact_connections,
           dependent: :delete_all,
           class_name: 'Contact::Connection'
  has_many :realms, through: :contact_connections
  has_many :contact_memberships,
           dependent: :delete_all,
           class_name: 'Contact::Membership'
  has_many :positions, through: :contact_memberships
  validates :title, presence: true
end
