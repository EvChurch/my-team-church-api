# frozen_string_literal: true

FactoryBot.define do
  factory :contact_membership, class: 'Contact::Membership' do
    organization
    contact
    position
  end
end
