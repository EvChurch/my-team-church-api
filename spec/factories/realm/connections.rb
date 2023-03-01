# frozen_string_literal: true

FactoryBot.define do
  factory :realm_connection, class: 'Realm::Connection' do
    account
    realm
    subject factory: :contact
  end
end
