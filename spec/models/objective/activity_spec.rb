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

  describe '#contact_is_member_of_team' do
    it 'returns validation error' do
      activity.contact = create(:contact)
      activity.save
      expect(activity.errors[:contact_id]).to eq(['contact must be member of team'])
    end
  end

  describe '#result_belongs_to_objective' do
    it 'returns validation error' do
      activity.result = create(:objective_result)
      activity.save
      expect(activity.errors[:result_id]).to eq(['result must belong to objective'])
    end
  end

  describe '#update_result' do
    subject(:activity) { build(:objective_activity, objective:, result:, progress: 'on_track', current_value: 10.0) }

    let(:objective) { create(:objective) }
    let!(:result) { create(:objective_result, objective:, progress: 'off_track', current_value: 5.0) }

    it 'updates the result' do
      activity.save
      expect(result.reload).to have_attributes(progress: 'on_track', current_value: 10.0)
    end

    context 'when progress is nil' do
      subject(:activity) { build(:objective_activity, objective:, result:, current_value: 10.0) }

      it 'updates the result' do
        activity.save
        expect(result.reload).to have_attributes(progress: 'off_track', current_value: 10.0)
      end
    end

    context 'when current_value is nil' do
      subject(:activity) { build(:objective_activity, objective:, result:, progress: 'on_track') }

      it 'updates the result' do
        activity.save
        expect(result.reload).to have_attributes(progress: 'on_track', current_value: 5.0)
      end
    end
  end
end
