# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Team::Assignment do
  subject(:position) { create(:team_assignment) }

  it { is_expected.to have_db_column(:account_id).of_type(:uuid).with_options(null: false) }
  it { is_expected.to have_db_column(:position_id).of_type(:uuid).with_options(null: false) }
  it { is_expected.to have_db_column(:contact_id).of_type(:uuid).with_options(null: false) }
  it { is_expected.to have_db_column(:created_at).of_type(:datetime).with_options(null: false) }
  it { is_expected.to have_db_column(:updated_at).of_type(:datetime).with_options(null: false) }
  it { is_expected.to validate_uniqueness_of(:position_id).scoped_to(:contact_id).case_insensitive }
  it { is_expected.to belong_to(:position) }
  it { is_expected.to belong_to(:contact) }
end
