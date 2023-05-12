# frozen_string_literal: true

FactoryBot.define do
  factory :team_position, class: 'Team::Position' do
    title { Faker::Company.name }
    team
  end
end
