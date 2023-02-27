# frozen_string_literal: true

class Team < ApplicationRecord
  extend FriendlyId
  friendly_id :title, use: :scoped, scope: [:organization_id]
  has_ancestry primary_key_format: %r{\A[\w-]+(/[\w-]+)*\z}
  multi_tenant :organization
  has_many :contact_memberships, dependent: :delete_all, class_name: 'Contact::Membership'
  has_many :contacts, through: :contact_memberships
  validates :title, presence: true
end
