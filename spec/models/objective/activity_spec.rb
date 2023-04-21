# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Objective::Activity do
  subject(:activity) { create(:objective_activity) }

  it { is_expected.to have_db_column(:account_id).of_type(:uuid).with_options(null: false) }
  it { is_expected.to have_db_column(:result_id).of_type(:uuid) }
  it { is_expected.to have_db_column(:contact_id).of_type(:uuid).with_options(null: false) }
  it { is_expected.to have_db_column(:current_value).of_type(:decimal) }
  it { is_expected.to have_db_column(:progress).of_type(:string) }
  it { is_expected.to have_db_column(:comment).of_type(:string) }
  it { is_expected.to belong_to(:objective) }
  it { is_expected.to belong_to(:result).optional }
  it { is_expected.to belong_to(:contact) }

  it {
    expect(activity).to define_enum_for(:kind).with_values(
      progress_update: 'progress_update', note: 'note'
    ).backed_by_column_of_type(:string)
  }

  it {
    expect(activity).to define_enum_for(:progress).with_values(
      Objective.progresses
    ).backed_by_column_of_type(:string)
  }

  describe '#update_result' do
    subject(:activity) { build(:objective_activity, result:, progress: 'on_track', current_value: 10.0) }

    let!(:result) { create(:objective_result, progress: 'off_track', current_value: 5.0) }

    it 'updates the result' do
      activity.save
      expect(result.reload).to have_attributes(progress: 'on_track', current_value: 10.0)
    end

    context 'when progress is nil' do
      subject(:activity) { build(:objective_activity, result:, current_value: 10.0) }

      it 'updates the result' do
        activity.save
        expect(result.reload).to have_attributes(progress: 'off_track', current_value: 10.0)
      end
    end

    context 'when current_value is nil' do
      subject(:activity) { build(:objective_activity, result:, progress: 'on_track') }

      it 'updates the result' do
        activity.save
        expect(result.reload).to have_attributes(progress: 'on_track', current_value: 5.0)
      end
    end
  end
end
