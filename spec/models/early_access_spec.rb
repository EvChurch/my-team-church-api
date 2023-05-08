# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EarlyAccess do
  subject(:early_access) { create(:early_access) }

  it { is_expected.to have_db_column(:first_name).of_type(:string).with_options(null: false) }
  it { is_expected.to have_db_column(:email_address).of_type(:string).with_options(null: false) }
  it { is_expected.to have_db_index(:email_address).unique(true) }
  it { is_expected.to validate_presence_of(:first_name) }
  it { is_expected.to validate_presence_of(:email_address) }
  it { is_expected.to validate_uniqueness_of(:email_address).case_insensitive }
end
