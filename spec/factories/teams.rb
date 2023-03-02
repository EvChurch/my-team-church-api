# frozen_string_literal: true

FactoryBot.define do
  factory :team do
    account
    title { Faker::Company.name }
    definition { 'team' }
    remote_id { SecureRandom.uuid }
  end
end
