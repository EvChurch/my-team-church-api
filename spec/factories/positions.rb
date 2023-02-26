# frozen_string_literal: true

FactoryBot.define do
  factory :position do
    organization_id { '' }
    title { 'MyString' }
    ancestry { 'MyString' }
  end
end
