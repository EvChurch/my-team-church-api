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
  validates :account_id, uniqueness: true
  encrypts :api_key

  def import
    MultiTenant.with(account) do
      Fluro::ImportService.import_all(self)
    end
  end

  def should_generate_new_friendly_id?
    title_changed?
  end
end
