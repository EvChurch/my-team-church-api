# frozen_string_literal: true

FactoryBot.define do
  factory :contact do
    organization
    first_name { 'MyString' }
    last_name { 'MyString' }
    emails { 'MyText' }
  end
end
