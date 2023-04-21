# frozen_string_literal: true

FactoryBot.define do
  factory :objective_result_audit, class: 'Objective::Result::Audit' do
    result factory: :objective_result
    contact
  end
end
