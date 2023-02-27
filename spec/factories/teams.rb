# frozen_string_literal: true

FactoryBot.define do
  factory :team do
    organization
    title { Faker::Company.name }
    definition { 'team' }
  end
end
