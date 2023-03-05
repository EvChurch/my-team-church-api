# frozen_string_literal: true

class Application < ApplicationRecord
  extend FriendlyId
  friendly_id :title, use: :scoped, scope: [:account_id]
  multi_tenant :account
  has_many :realm_connections,
           dependent: :delete_all,
           class_name: 'Realm::Connection',
           as: :subject
  has_many :realms, through: :realm_connections
  validates :title, :definition, presence: true
  validates :remote_id, uniqueness: { scope: :account_id }, allow_nil: true
  encrypts :api_key
end
