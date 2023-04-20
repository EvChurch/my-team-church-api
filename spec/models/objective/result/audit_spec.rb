# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Objective::Result::Audit do
  subject(:audit) { create(:objective_result_audit) }

  it { is_expected.to have_db_column(:account_id).of_type(:uuid).with_options(null: false) }
  it { is_expected.to have_db_column(:result_id).of_type(:uuid).with_options(null: false) }
  it { is_expected.to have_db_column(:contact_id).of_type(:uuid).with_options(null: false) }
  it { is_expected.to have_db_column(:current_value).of_type(:decimal).with_options(null: false, default: 0.0) }
  it { is_expected.to have_db_column(:progress).of_type(:string).with_options(null: false, default: 'no_status') }
  it { is_expected.to have_db_column(:comment).of_type(:string) }
  it { is_expected.to belong_to(:result) }
  it { is_expected.to belong_to(:contact) }

  it {
    expect(audit).to define_enum_for(:progress).with_values(
      Objective.progresses
    ).backed_by_column_of_type(:string)
  }

  it { is_expected.to validate_presence_of(:current_value) }
  it { is_expected.to validate_presence_of(:progress) }

  describe '#update_result' do
    subject(:audit) { build(:objective_result_audit, result:, progress: 'on_track', current_value: 10.0) }

    let!(:result) { create(:objective_result) }

    it 'updates the result' do
      audit.save
      expect(result.reload).to have_attributes(progress: 'on_track', current_value: 10.0)
    end
  end
end