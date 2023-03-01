# frozen_string_literal: true

FactoryBot.define do
  factory :account do
    title { Faker::Company.name }
  end
end
