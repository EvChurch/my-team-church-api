# frozen_string_literal: true

FactoryBot.define do
  factory :contact_connection, class: 'Contact::Connection' do
    organization
    contact
    realm
  end
end
