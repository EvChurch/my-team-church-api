# frozen_string_literal: true

FactoryBot.define do
  factory :team_membership, class: 'Team::Membership' do
    organization
    contact
    team
  end
end
