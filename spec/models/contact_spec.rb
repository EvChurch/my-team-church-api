# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Contact do
  subject(:contact) { build(:contact) }

  it { is_expected.to have_many(:contact_connections).dependent(:delete_all) }
  it { is_expected.to have_many(:realms).through(:contact_connections) }
  it { is_expected.to have_many(:contact_memberships).dependent(:delete_all) }
  it { is_expected.to have_many(:positions).through(:contact_memberships) }
  it { is_expected.to validate_presence_of(:title) }
end
