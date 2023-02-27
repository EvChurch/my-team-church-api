# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Team do
  subject(:team) { build(:team) }

  it { is_expected.to have_many(:contact_memberships).dependent(:delete_all) }
  it { is_expected.to have_many(:contacts).through(:contact_memberships) }
  it { is_expected.to validate_presence_of(:title) }
end
