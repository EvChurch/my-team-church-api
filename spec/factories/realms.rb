# frozen_string_literal: true

FactoryBot.define do
  factory :realm do
    title { 'MyString' }
    remote_id { 'MyString' }
    color { 'MyString' }
    bg_color { 'MyString' }
    slug { 'MyString' }
    organization_id { '' }
    ancestry { 'MyString' }
  end
end
