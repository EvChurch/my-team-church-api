# frozen_string_literal: true

FactoryBot.define do
  factory :contact do
    title { Faker::Name.name }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    emails { [Faker::Internet.email] }
    phone_numbers { [Faker::PhoneNumber.phone_number] }
    definition { 'contact' }
    remote_id { SecureRandom.uuid }
  end
end
