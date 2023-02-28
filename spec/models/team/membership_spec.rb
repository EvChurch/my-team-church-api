# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Team::Membership do
  subject(:team_membership) { create(:team_membership) }

  it { is_expected.to have_db_column(:organization_id).of_type(:uuid).with_options(null: false) }
  it { is_expected.to have_db_column(:contact_id).of_type(:uuid).with_options(null: false) }
  it { is_expected.to have_db_column(:team_id).of_type(:uuid).with_options(null: false) }
  it { is_expected.to have_db_column(:created_at).of_type(:datetime).with_options(null: false) }
  it { is_expected.to have_db_column(:updated_at).of_type(:datetime).with_options(null: false) }
  it { is_expected.to belong_to(:contact) }
  it { is_expected.to belong_to(:team) }
end
