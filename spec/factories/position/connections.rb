# frozen_string_literal: true

FactoryBot.define do
  factory :team_connection, class: 'Team::Connection' do
    realm
    organization
    team
  end
end
