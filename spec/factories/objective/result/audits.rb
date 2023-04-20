# frozen_string_literal: true

FactoryBot.define do
  factory :objective_result_audit, class: 'Objective::Result::Audit' do
    result factory: :objective_result
    contact
    current_value { 0.0 }
    progress { Objective.progresses[:no_status] }
  end
end
