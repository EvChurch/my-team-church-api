# frozen_string_literal: true

FactoryBot.define do
  factory :objective do
    contact
    team
    title { Faker::Name.name }
    status { Objective.statuses['active'] }
    due_at { Time.zone.today }

    after(:build) do |objective|
      objective.team.contacts = [objective.contact]
    end
  end
end
