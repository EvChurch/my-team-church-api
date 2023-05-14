# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Team::Assignment do
  subject(:assignment) { create(:team_assignment) }

  it { is_expected.to have_db_column(:account_id).of_type(:uuid).with_options(null: false) }
  it { is_expected.to have_db_column(:position_id).of_type(:uuid).with_options(null: false) }
  it { is_expected.to have_db_column(:contact_id).of_type(:uuid).with_options(null: false) }
  it { is_expected.to have_db_column(:created_at).of_type(:datetime).with_options(null: false) }
  it { is_expected.to have_db_column(:updated_at).of_type(:datetime).with_options(null: false) }
  it { is_expected.to have_db_column(:progress).of_type(:string).with_options(null: false, default: 'no_status') }
  it { is_expected.to validate_uniqueness_of(:position_id).scoped_to(:contact_id).case_insensitive }
  it { is_expected.to belong_to(:position) }
  it { is_expected.to belong_to(:contact) }

  it {
    expect(assignment).to define_enum_for(:progress).with_values(
      no_status: 'no_status', off_track: 'off_track', needs_attention: 'needs_attention', on_track: 'on_track'
    ).backed_by_column_of_type(:string)
  }

  describe '#update_position_summary' do
    it 'updates position progress' do
      assignment.update(progress: :off_track)
      expect(assignment.position.progress).to eq('off_track')
    end
  end
end
