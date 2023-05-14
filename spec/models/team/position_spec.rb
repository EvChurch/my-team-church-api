# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Team::Position do
  subject(:position) { create(:team_position) }

  it { is_expected.to have_db_column(:account_id).of_type(:uuid).with_options(null: false) }
  it { is_expected.to have_db_column(:team_id).of_type(:uuid).with_options(null: false) }
  it { is_expected.to have_db_column(:slug).of_type(:string).with_options(null: false) }
  it { is_expected.to have_db_column(:title).of_type(:string).with_options(null: false) }
  it { is_expected.to have_db_column(:remote_id).of_type(:string) }
  it { is_expected.to have_db_column(:exclude).of_type(:boolean).with_options(null: false, default: false) }
  it { is_expected.to have_db_column(:reporter).of_type(:boolean).with_options(null: false, default: false) }
  it { is_expected.to have_db_column(:created_at).of_type(:datetime).with_options(null: false) }
  it { is_expected.to have_db_column(:updated_at).of_type(:datetime).with_options(null: false) }
  it { is_expected.to have_db_column(:assignments_count).of_type(:integer).with_options(null: false, default: 0) }

  it {
    expect(position).to have_db_column(:required_assignments_count).of_type(:integer).with_options(null: false,
                                                                                                   default: 0)
  }

  it { is_expected.to have_db_column(:progress).of_type(:string).with_options(null: false, default: 'no_status') }
  it { is_expected.to validate_presence_of(:title) }
  it { is_expected.to validate_uniqueness_of(:remote_id).scoped_to(%i[account_id team_id]).allow_nil }
  it { is_expected.to belong_to(:team) }
  it { is_expected.to have_many(:assignments).dependent(:delete_all) }
  it { is_expected.to have_many(:contacts).through(:assignments) }

  it {
    expect(position).to define_enum_for(:progress).with_values(
      no_status: 'no_status', off_track: 'off_track', needs_attention: 'needs_attention', on_track: 'on_track'
    ).backed_by_column_of_type(:string)
  }

  describe '#should_generate_new_friendly_id?' do
    it 'updates slug when title changes' do
      position.update(title: 'this is a test')
      expect(position.slug).to eq 'this-is-a-test'
    end
  end

  describe '#friendly_id_title' do
    subject(:position) { build(:team_position, title: 'Admin') }

    it 'changes admin slug to administrator' do
      position.save
      expect(position.slug).to eq 'administrator'
    end
  end

  describe '#update_summary' do
    it 'updates progress' do
      create(:team_assignment, position:, progress: :off_track)
      create(:team_assignment, position:, progress: :on_track)
      expect(position.progress).to eq('off_track')
    end
  end
end
