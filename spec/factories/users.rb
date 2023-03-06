# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    title { Faker::Name.name }
  end
end
