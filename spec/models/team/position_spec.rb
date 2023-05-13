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
  it { is_expected.to validate_presence_of(:title) }
  it { is_expected.to validate_uniqueness_of(:remote_id).scoped_to(%i[account_id team_id]).allow_nil }
  it { is_expected.to belong_to(:team) }
  it { is_expected.to have_many(:assignments).dependent(:delete_all) }
  it { is_expected.to have_many(:contacts).through(:assignments) }

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
end