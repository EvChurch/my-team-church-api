# frozen_string_literal: true

FactoryBot.define do
  factory :team do
    organization
    title { 'MyString' }
  end
end
