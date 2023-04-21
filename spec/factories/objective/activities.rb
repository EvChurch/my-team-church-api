# frozen_string_literal: true

FactoryBot.define do
  factory :objective_activity, class: 'Objective::Activity' do
    result { create(:objective_result, objective:) }
    objective
    contact { objective.contact }
  end
end
