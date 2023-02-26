# frozen_string_literal: true

FactoryBot.define do
  factory :position_connection, class: 'Position::Connection' do
    realm
    organization
    position
  end
end
