# frozen_string_literal: true

FactoryBot.define do
  factory :position do
    organization
    title { 'MyString' }
  end
end
