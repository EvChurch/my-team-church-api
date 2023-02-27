# frozen_string_literal: true

class Organization < ApplicationRecord
  extend FriendlyId
  friendly_id :title, use: :slugged
  has_many :contacts, dependent: :delete_all
  has_many :realms, dependent: :delete_all
  validates :title, presence: true
  encrypts :fluro_api_key

  def import
    MultiTenant.with(self) do
      Fluro::ImportService.import(self)
    end
  end
end
