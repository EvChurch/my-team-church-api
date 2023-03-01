# frozen_string_literal: true

FactoryBot.define do
  factory :team do
    account
    title { Faker::Company.name }
    definition { 'team' }
  end
end
