# frozen_string_literal: true

FactoryBot.define do
  factory :realm do
    organization
    title { 'MyString' }
    color { 'MyString' }
    bg_color { 'MyString' }
    slug { 'MyString' }
  end
end
