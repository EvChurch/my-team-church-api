# frozen_string_literal: true

class Realm < ApplicationRecord
  has_ancestry
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
