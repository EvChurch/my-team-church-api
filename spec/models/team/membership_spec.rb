# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Team::Membership do
  subject(:team_membership) { create(:team_membership) }

  it { is_expected.to belong_to(:contact) }
  it { is_expected.to belong_to(:team) }
end
