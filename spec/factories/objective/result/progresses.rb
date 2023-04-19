# frozen_string_literal: true

FactoryBot.define do
  factory :objective_result_progress, class: 'Objective::Result::Progress' do
    result factory: :objective_result
    contact
    current_value { 0.0 }
    progress { Objective::Result.progresses['no_status'] }
  end
end
