# frozen_string_literal: true

class User < ApplicationRecord
  extend FriendlyId
  friendly_id :title, use: :slugged
  multi_tenant :account
  has_many :contact_connections,
           dependent: :delete_all,
           class_name: 'Contact::Connection'
  has_many :contacts, through: :contact_connections
  has_many :teams, -> { distinct }, through: :contacts
  validates :title, presence: true
  validates :remote_id, uniqueness: { scope: :account_id }, allow_nil: true

  def self.login(remote)
    user = find_or_initialize_by(remote_id: remote['_id'])
    user.update!(remote_attributes(remote))
    user.contacts = Contact.where(remote_id: remote['contacts'])
    { user:, token: JsonWebTokenService.encode(user_id: user.id, account_id: user.account_id) }
  end

  def self.remote_attributes(remote)
    {
      title: remote['name'],
      first_name: remote['firstName'],
      last_name: remote['lastName'],
      email: remote['email'],
      phone_number: remote['phoneNumber'],
      created_at: remote['created']
    }
  end

  def should_generate_new_friendly_id?
    title_changed?
  end
end
