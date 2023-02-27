# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Realm do
  subject(:realm) { create(:realm) }

  it { is_expected.to have_db_column(:organization_id).of_type(:uuid).with_options(null: false) }
  it { is_expected.to have_db_column(:ancestry).of_type(:string) }
  it { is_expected.to have_db_column(:definition).of_type(:string).with_options(null: false) }
  it { is_expected.to have_db_column(:slug).of_type(:string).with_options(null: false) }
  it { is_expected.to have_db_column(:status).of_type(:string).with_options(default: 'active') }
  it { is_expected.to have_db_column(:title).of_type(:string).with_options(null: false) }
  it { is_expected.to have_db_column(:remote_id).of_type(:string) }
  it { is_expected.to have_db_column(:color).of_type(:string) }
  it { is_expected.to have_db_column(:bg_color).of_type(:string) }
  it { is_expected.to have_db_column(:created_at).of_type(:datetime).with_options(null: false) }
  it { is_expected.to have_db_column(:updated_at).of_type(:datetime).with_options(null: false) }
  it { is_expected.to have_many(:connections).dependent(:delete_all) }
  it { is_expected.to have_many(:contacts).through(:connections) }
  it { is_expected.to have_many(:teams).through(:connections) }

  it {
    expect(realm).to define_enum_for(:status).with_values(
      active: 'active', archived: 'archived', draft: 'draft'
    ).backed_by_column_of_type(:string)
  }

  it { is_expected.to validate_presence_of(:title) }
end
