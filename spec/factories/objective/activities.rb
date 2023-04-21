# frozen_string_literal: true

FactoryBot.define do
  factory :objective_activity, class: 'Objective::Activity' do
    result factory: :objective_result
    objective
    contact
  end
end
