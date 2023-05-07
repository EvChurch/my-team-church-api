# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Objective do
  subject(:objective) { create(:objective) }

  it { is_expected.to have_db_column(:account_id).of_type(:uuid).with_options(null: false) }
  it { is_expected.to have_db_column(:team_id).of_type(:uuid).with_options(null: false) }
  it { is_expected.to have_db_column(:contact_id).of_type(:uuid).with_options(null: false) }
  it { is_expected.to have_db_column(:title).of_type(:string).with_options(null: false) }
  it { is_expected.to have_db_column(:description).of_type(:string) }
  it { is_expected.to have_db_column(:due_at).of_type(:date) }
  it { is_expected.to have_db_column(:status).of_type(:string).with_options(default: 'draft') }
  it { is_expected.to have_db_column(:progress).of_type(:string).with_options(null: false, default: 'no_status') }
  it { is_expected.to have_db_column(:percentage).of_type(:decimal).with_options(null: false, default: 0.0) }
  it { is_expected.to belong_to(:team) }
  it { is_expected.to belong_to(:contact) }
  it { is_expected.to have_many(:results).dependent(:delete_all) }
  it { is_expected.to have_many(:activities) }

  it {
    expect(objective).to define_enum_for(:status).with_values(
      active: 'active', archived: 'archived', draft: 'draft'
    ).backed_by_column_of_type(:string)
  }

  it {
    expect(objective).to define_enum_for(:progress).with_values(
      no_status: 'no_status', off_track: 'off_track', needs_attention: 'needs_attention', on_track: 'on_track',
      accomplished: 'accomplished'
    ).backed_by_column_of_type(:string)
  }

  it { is_expected.to validate_presence_of(:title) }

  describe '#contact_is_member_of_team' do
    it 'returns validation error' do
      objective.contact = create(:contact)
      objective.save
      expect(objective.errors[:contact_id]).to eq(['contact must be member of team'])
    end
  end

  describe '#update_summary' do
    it 'updates percentage' do
      create(:objective_result, objective:, start_value: 0, target_value: 100, current_value: 40)
      expect(objective.percentage).to eq(40)
    end

    it 'updates progress' do
      create(:objective_result, objective:, progress: :off_track)
      create(:objective_result, objective:, progress: :on_track)
      expect(objective.progress).to eq('off_track')
    end
  end

  describe '#update_percentage' do
    it 'updates percentage with sum of key result percentages over number of key results' do
      create(:objective_result, objective:, start_value: 0, target_value: 100, current_value: 40)
      create(:objective_result, objective:, start_value: 0, target_value: 100, current_value: 60)
      expect(objective.percentage).to eq(50)
    end

    context 'when no results' do
      it 'updates percentage with 0' do
        result = create(:objective_result, objective:, start_value: 0, target_value: 100, current_value: 40)
        result.destroy
        expect(objective.percentage).to eq(0)
      end
    end

    context 'when kind changes to initiative' do
      it 'updates percentage ignoring initiative' do
        create(:objective_result, objective:, start_value: 0, target_value: 100, current_value: 40)
        result = create(:objective_result, objective:, start_value: 0, target_value: 100, current_value: 60)
        result.update(kind: :initiative)
        expect(objective.percentage).to eq(40)
      end
    end
  end

  describe '#update_progress' do
    it 'updates progress with lowest progress' do
      create(:objective_result, objective:, progress: :off_track)
      create(:objective_result, objective:, progress: :on_track)
      expect(objective.progress).to eq('off_track')
    end

    context 'when no results' do
      it 'updates progress with no_status' do
        result = create(:objective_result, objective:, progress: :on_track)
        result.destroy
        expect(objective.progress).to eq('no_status')
      end
    end

    context 'when no_status is option' do
      it 'updates progress with lowest progress ignoring no_status' do
        create(:objective_result, objective:, progress: :no_status)
        create(:objective_result, objective:, progress: :on_track)
        expect(objective.progress).to eq('on_track')
      end
    end
  end
end
