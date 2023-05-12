# frozen_string_literal: true

FactoryBot.define do
  factory :team_assignment, class: 'Team::Assignment' do
    contact
    position factory: :team_position
  end
end
