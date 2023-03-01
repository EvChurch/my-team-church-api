# frozen_string_literal: true

FactoryBot.define do
  factory :realm do
    account
    title { Faker::Company.name }
    color { Faker::Color.hex_color }
    bg_color { Faker::Color.hex_color }
    definition { 'realm' }
  end
end
