# frozen_string_literal: true

class Position < ApplicationRecord
  has_ancestry
  multi_tenant :organization
  has_many :contact_memberships, dependent: :delete_all, class_name: 'Contact::Membership'
  has_many :contacts, through: :contact_memberships
  validates :title, presence: true
end
