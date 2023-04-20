# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Objective::Result do
  subject(:result) { create(:objective_result) }

  it { is_expected.to have_db_column(:account_id).of_type(:uuid).with_options(null: false) }
  it { is_expected.to have_db_column(:objective_id).of_type(:uuid).with_options(null: false) }
  it { is_expected.to have_db_column(:title).of_type(:string).with_options(null: false) }
  it { is_expected.to have_db_column(:description).of_type(:string) }
  it { is_expected.to have_db_column(:contact_id).of_type(:uuid).with_options(null: false) }
  it { is_expected.to have_db_column(:measurement).of_type(:string).with_options(null: false, default: 'numerical') }
  it { is_expected.to have_db_column(:kind).of_type(:string).with_options(null: false, default: 'key_result') }
  it { is_expected.to have_db_column(:progress).of_type(:string).with_options(null: false, default: 'no_status') }
  it { is_expected.to have_db_column(:start_value).of_type(:decimal).with_options(null: false, default: 0.0) }
  it { is_expected.to have_db_column(:current_value).of_type(:decimal) }
  it { is_expected.to have_db_column(:target_value).of_type(:decimal).with_options(null: false, default: 100.0) }
  it { is_expected.to have_db_column(:start_at).of_type(:date) }
  it { is_expected.to have_db_column(:due_at).of_type(:date) }
  it { is_expected.to have_db_column(:status).of_type(:string).with_options(null: false, default: 'draft') }
  it { is_expected.to belong_to(:objective) }
  it { is_expected.to belong_to(:contact) }
  it { is_expected.to have_many(:audits).dependent(:delete_all) }

  it {
    expect(result).to define_enum_for(:measurement).with_values(
      numerical: 'numerical', percentage: 'percentage', currency: 'currency'
    ).backed_by_column_of_type(:string)
  }

  it {
    expect(result).to define_enum_for(:kind).with_values(
      key_result: 'key_result', initiative: 'initiative'
    ).backed_by_column_of_type(:string)
  }

  it {
    expect(result).to define_enum_for(:progress).with_values(
      Objective.progresses
    ).backed_by_column_of_type(:string)
  }

  it {
    expect(result).to define_enum_for(:status).with_values(
      active: 'active', archived: 'archived', draft: 'draft'
    ).backed_by_column_of_type(:string)
  }

  it { is_expected.to validate_presence_of(:title) }
  it { is_expected.to validate_presence_of(:measurement) }
  it { is_expected.to validate_presence_of(:kind) }
  it { is_expected.to validate_presence_of(:progress) }
  it { is_expected.to validate_presence_of(:start_value) }
  it { is_expected.to validate_presence_of(:target_value) }
  it { is_expected.to validate_presence_of(:status) }

  describe '#start_value_must_not_equal_target_value' do
    subject(:result) { build(:objective_result, start_value: 10, target_value: 10) }

    it 'is invalid when start_value equals target_value' do
      expect do
        result.save!
      end.to raise_error(ActiveRecord::RecordInvalid, 'Validation failed: Start value must not equal target value')
    end
  end

  describe '#update_percentage' do
    subject(:result) { build(:objective_result, start_value: 10, target_value: 20, current_value: 15) }

    it 'updates the percentage' do
      expect do
        result.save!
      end.to change(result, :percentage).from(0).to(50)
    end

    context 'when current_value is nil' do
      subject(:result) do
        build(:objective_result, start_value: 10, target_value: 20, current_value: nil, percentage: 10)
      end

      it 'updates the percentage' do
        expect do
          result.save!
        end.to change(result, :percentage).from(10).to(0)
      end
    end

    context 'when start_value is greater than target_value' do
      subject(:result) { build(:objective_result, start_value: 20, target_value: 10, current_value: 15) }

      it 'updates the percentage' do
        expect do
          result.save!
        end.to change(result, :percentage).from(0).to(50)
      end
    end
  end
end
