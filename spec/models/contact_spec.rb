# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Contact do
  subject(:contact) { create(:contact, remote_id: 'remote_id') }

  it { is_expected.to have_db_column(:account_id).of_type(:uuid).with_options(null: false) }
  it { is_expected.to have_db_column(:definition).of_type(:string).with_options(null: false) }
  it { is_expected.to have_db_column(:slug).of_type(:string).with_options(null: false) }
  it { is_expected.to have_db_column(:status).of_type(:string).with_options(default: 'active') }
  it { is_expected.to have_db_column(:title).of_type(:string).with_options(null: false) }
  it { is_expected.to have_db_column(:avatar).of_type(:string) }
  it { is_expected.to have_db_column(:remote_id).of_type(:string) }
  it { is_expected.to have_db_column(:first_name).of_type(:string) }
  it { is_expected.to have_db_column(:last_name).of_type(:string) }
  it { is_expected.to have_db_column(:emails).of_type(:text).with_options(default: [], array: true) }
  it { is_expected.to have_db_column(:phone_numbers).of_type(:text).with_options(default: [], array: true) }
  it { is_expected.to have_db_column(:created_at).of_type(:datetime).with_options(null: false) }
  it { is_expected.to have_db_column(:updated_at).of_type(:datetime).with_options(null: false) }
  it { is_expected.to have_many(:realm_connections).dependent(:delete_all) }
  it { is_expected.to have_many(:realms).through(:realm_connections) }
  it { is_expected.to have_many(:memberships).dependent(:delete_all) }
  it { is_expected.to have_many(:teams).through(:memberships) }
  it { is_expected.to have_many(:objectives).dependent(:delete_all) }
  it { is_expected.to have_many(:results).dependent(:delete_all) }
  it { is_expected.to have_many(:audits).dependent(:delete_all) }

  it {
    expect(contact).to define_enum_for(:status).with_values(
      active: 'active', archived: 'archived', draft: 'draft'
    ).backed_by_column_of_type(:string)
  }

  it { is_expected.to validate_presence_of(:title) }
  it { is_expected.to validate_presence_of(:definition) }
  it { is_expected.to validate_uniqueness_of(:remote_id).scoped_to(:account_id).allow_nil }

  describe '#should_generate_new_friendly_id?' do
    it 'updates slug when title changes' do
      contact.update(title: 'this is a test')
      expect(contact.slug).to eq 'this-is-a-test'
    end
  end
end
