# frozen_string_literal: true

FactoryBot.define do
  factory :objective do
    contact
    team
    title { Faker::Name.name }
    status { Objective.statuses['active'] }
  end
end
