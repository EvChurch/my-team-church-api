# frozen_string_literal: true

FactoryBot.define do
  factory :objective_result, class: 'Objective::Result' do
    objective
    title { 'MyString' }
    description { 'MyString' }
    contact
    measurement { Objective::Result.measurements['numerical'] }
    kind { Objective::Result.kinds['key_result'] }
    progress { Objective::Result.progresses['no_status'] }
    status { Objective::Result.statuses['draft'] }
    start_value { 0 }
    target_value { 100 }
  end
end
