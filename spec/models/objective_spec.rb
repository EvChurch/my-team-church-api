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
  it { is_expected.to belong_to(:team) }
  it { is_expected.to belong_to(:contact) }

  it {
    expect(objective).to define_enum_for(:status).with_values(
      active: 'active', archived: 'archived', draft: 'draft'
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
end
