# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Team do
  subject(:team) { create(:team) }

  it { is_expected.to have_many(:realm_connections).dependent(:delete_all) }
  it { is_expected.to have_many(:realms).through(:realm_connections) }
  it { is_expected.to have_many(:memberships).dependent(:delete_all) }
  it { is_expected.to have_many(:contacts).through(:memberships) }
  it { is_expected.to define_enum_for(:status).with_values(active: 'active', archived: 'archived', draft: 'draft') }
  it { is_expected.to validate_presence_of(:title) }
end
