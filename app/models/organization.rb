# frozen_string_literal: true

class Organization < ApplicationRecord
  extend FriendlyId
  friendly_id :title, use: :slugged
  has_many :contacts, dependent: :delete_all
  has_many :realms, dependent: :delete_all
  has_many :realm_connections, dependent: :delete_all, class_name: 'Realm::Connection'
  has_many :teams, dependent: :delete_all
  has_many :team_memberships, dependent: :delete_all, class_name: 'Team::Membership'
  validates :title, presence: true
  encrypts :fluro_api_key

  def import
    MultiTenant.with(self) do
      Fluro::ImportService.import(self)
    end
  end
end
