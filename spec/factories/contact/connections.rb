# frozen_string_literal: true

FactoryBot.define do
  factory :contact_connection, class: 'Contact::Connection' do
    contact
    user
  end
end
