# frozen_string_literal: true

class Account < ApplicationRecord
  extend FriendlyId
  friendly_id :title, use: :slugged
  has_many :applications, dependent: :delete_all
  has_many :contacts, dependent: :delete_all
  has_many :realms, dependent: :delete_all
  has_many :realm_connections, dependent: :delete_all, class_name: 'Realm::Connection'
  has_many :teams, dependent: :delete_all
  has_many :team_memberships, dependent: :delete_all, class_name: 'Team::Membership'
  validates :title, presence: true
  validates :remote_id, uniqueness: true, allow_nil: true

  def import
    MultiTenant.with(self) do
      Fluro::ImportService.import_all(self)
    end
  end

  def self.import(api_key)
    client = Fluro::ClientService.new(api_key)
    remote_application = client.session
    remote_account_id = remote_application.dig('account', '_id')
    remote_account = client.account(remote_account_id)
    account = Account.find_or_initialize_by(remote_id: remote_account['_id'])
    account.update!(
      title: remote_account['title'],
      status: remote_account['status'],
      created_at: remote_account['created'],
      updated_at: remote_account['updated']
    )
    application = account.applications.find_or_initialize_by(remote_id: remote_application['_id'])
    application.update!(
      definition: remote_application['definition'] || remote_application['_type'],
      title: remote_application['title'],
      status: remote_application['status'],
      created_at: remote_application['created'],
      updated_at: remote_application['updated'],
      api_key:
    )
  end
end
