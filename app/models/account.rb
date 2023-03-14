# frozen_string_literal: true

class Account < ApplicationRecord
  extend FriendlyId
  friendly_id :title, use: :slugged
  has_one :application, dependent: :delete
  has_many :contacts, dependent: :delete_all
  has_many :realms, dependent: :delete_all
  has_many :realm_connections, dependent: :delete_all, class_name: 'Realm::Connection'
  has_many :teams, dependent: :delete_all
  has_many :team_memberships, dependent: :delete_all, class_name: 'Team::Membership'
  has_many :users, dependent: :delete_all
  validates :title, presence: true
  validates :remote_id, uniqueness: true, allow_nil: true

  def self.import_all(api_key)
    Fluro::Import::ApplicationService.import_all(api_key)
  end

  def should_generate_new_friendly_id?
    title_changed?
  end
end
