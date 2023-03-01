# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Account do
  subject(:account) { create(:account) }

  it { is_expected.to have_db_column(:title).of_type(:string).with_options(null: false) }
  it { is_expected.to have_db_column(:slug).of_type(:string).with_options(null: false) }
  it { is_expected.to have_db_column(:fluro_api_key).of_type(:string) }
  it { is_expected.to have_db_column(:created_at).of_type(:datetime).with_options(null: false) }
  it { is_expected.to have_db_column(:updated_at).of_type(:datetime).with_options(null: false) }
  it { is_expected.to have_many(:contacts).dependent(:delete_all) }
  it { is_expected.to have_many(:realms).dependent(:delete_all) }
  it { is_expected.to have_many(:realm_connections).dependent(:delete_all) }
  it { is_expected.to have_many(:teams).dependent(:delete_all) }
  it { is_expected.to have_many(:team_memberships).dependent(:delete_all) }
  it { is_expected.to validate_presence_of(:title) }
end
