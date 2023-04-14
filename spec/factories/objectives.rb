# frozen_string_literal: true

FactoryBot.define do
  factory :objective do
    objectable { create(:contact) }
    title { Faker::Name.name }
    status { Objective.statuses['active'] }
  end
end
