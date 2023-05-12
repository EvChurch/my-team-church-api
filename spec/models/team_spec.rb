# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Team do
  subject(:team) { create(:team) }

  it { is_expected.to have_db_column(:account_id).of_type(:uuid).with_options(null: false) }
  it { is_expected.to have_db_column(:ancestry).of_type(:string) }
  it { is_expected.to have_db_column(:definition).of_type(:string).with_options(null: false) }
  it { is_expected.to have_db_column(:slug).of_type(:string).with_options(null: false) }
  it { is_expected.to have_db_column(:status).of_type(:string).with_options(default: 'active') }
  it { is_expected.to have_db_column(:title).of_type(:string).with_options(null: false) }
  it { is_expected.to have_db_column(:remote_id).of_type(:string) }
  it { is_expected.to have_db_column(:created_at).of_type(:datetime).with_options(null: false) }
  it { is_expected.to have_db_column(:updated_at).of_type(:datetime).with_options(null: false) }
  it { is_expected.to have_db_column(:visible_members).of_type(:boolean) }
  it { is_expected.to have_db_column(:progress).of_type(:string).with_options(null: false, default: 'no_status') }
  it { is_expected.to have_db_column(:percentage).of_type(:integer).with_options(null: false, default: 0) }
  it { is_expected.to have_many(:realm_connections).dependent(:delete_all) }
  it { is_expected.to have_many(:realms).through(:realm_connections) }
  it { is_expected.to have_many(:memberships).dependent(:delete_all) }
  it { is_expected.to have_many(:contacts).through(:memberships) }
  it { is_expected.to have_many(:objectives).dependent(:delete_all) }
  it { is_expected.to have_many(:positions).dependent(:delete_all) }
  it { is_expected.to have_many(:assignments).through(:positions) }

  it {
    expect(team).to define_enum_for(:status).with_values(
      active: 'active', archived: 'archived', draft: 'draft'
    ).backed_by_column_of_type(:string)
  }

  it {
    expect(team).to define_enum_for(:progress).with_values(
      no_status: 'no_status', off_track: 'off_track', needs_attention: 'needs_attention', on_track: 'on_track',
      accomplished: 'accomplished'
    ).backed_by_column_of_type(:string)
  }

  it { is_expected.to validate_presence_of(:title) }
  it { is_expected.to validate_presence_of(:definition) }
  it { is_expected.to validate_uniqueness_of(:remote_id).scoped_to(:account_id).allow_nil }

  describe '#should_generate_new_friendly_id?' do
    it 'updates slug when title changes' do
      team.update(title: 'this is a test')
      expect(team.slug).to eq 'this-is-a-test'
    end
  end

  describe '#friendly_id_title' do
    subject(:team) { build(:team, title: 'Admin') }

    it 'changes admin slug to administrator' do
      team.save
      expect(team.slug).to eq 'administrator'
    end
  end

  describe '#update_summary' do
    let(:objective) { create(:objective, team:) }

    it 'updates percentage' do
      create(:objective_result, objective:, start_value: 0, target_value: 100, current_value: 40)
      expect(team.percentage).to eq(40)
    end

    it 'updates progress' do
      create(:objective_result, objective:, progress: :off_track)
      create(:objective_result, objective:, progress: :on_track)
      expect(team.progress).to eq('off_track')
    end
  end

  describe '#update_percentage' do
    let(:objective) { create(:objective, team:) }

    it 'updates percentage with sum of key result percentages over number of key results' do
      create(:objective_result, objective:, start_value: 0, target_value: 100, current_value: 40)
      create(:objective_result, objective:, start_value: 0, target_value: 100, current_value: 60)
      expect(team.percentage).to eq(50)
    end

    context 'when no results' do
      it 'updates percentage with 0' do
        result = create(:objective_result, objective:, start_value: 0, target_value: 100, current_value: 40)
        result.destroy
        expect(team.percentage).to eq(0)
      end
    end

    context 'when kind changes to initiative' do
      it 'updates percentage ignoring initiative' do
        create(:objective_result, objective:, start_value: 0, target_value: 100, current_value: 40)
        result = create(:objective_result, objective:, start_value: 0, target_value: 100, current_value: 60)
        result.update(kind: :initiative)
        expect(team.percentage).to eq(40)
      end
    end
  end

  describe '#update_progress' do
    let(:objective) { create(:objective, team:) }

    it 'updates progress with lowest progress' do
      create(:objective_result, objective:, progress: :off_track)
      create(:objective_result, objective:, progress: :on_track)
      expect(team.progress).to eq('off_track')
    end

    context 'when no results' do
      it 'updates progress with no_status' do
        result = create(:objective_result, objective:, progress: :on_track)
        result.destroy
        expect(team.progress).to eq('no_status')
      end
    end

    context 'when no_status is option' do
      it 'updates progress with lowest progress ignoring no_status' do
        create(:objective_result, objective:, progress: :no_status)
        create(:objective_result, objective:, progress: :on_track)
        expect(team.progress).to eq('on_track')
      end
    end
  end
end
