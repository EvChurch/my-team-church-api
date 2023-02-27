# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Team::Connection do
  subject(:team_connection) { build(:team_connection) }

  it { is_expected.to belong_to(:team) }
  it { is_expected.to belong_to(:realm) }
end
