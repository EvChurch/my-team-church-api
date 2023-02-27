# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Realm::Connection do
  subject(:realm_connection) { create(:realm_connection) }

  it { is_expected.to have_db_column(:organization_id).of_type(:uuid).with_options(null: false) }
  it { is_expected.to have_db_column(:subject_type).of_type(:string).with_options(null: false) }
  it { is_expected.to have_db_column(:subject_id).of_type(:uuid).with_options(null: false) }
  it { is_expected.to have_db_column(:realm_id).of_type(:uuid).with_options(null: false) }
  it { is_expected.to have_db_column(:created_at).of_type(:datetime).with_options(null: false) }
  it { is_expected.to have_db_column(:updated_at).of_type(:datetime).with_options(null: false) }
  it { is_expected.to belong_to(:realm) }
  it { is_expected.to belong_to(:subject) }
  it { is_expected.to validate_uniqueness_of(:realm_id).scoped_to(:subject_id, :subject_type).case_insensitive }
end
