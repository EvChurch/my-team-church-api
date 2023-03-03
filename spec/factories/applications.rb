# frozen_string_literal: true

FactoryBot.define do
  factory :application do
    account
    title { Faker::Name.name }
    definition { 'application' }
    remote_id { SecureRandom.uuid }
  end
end
