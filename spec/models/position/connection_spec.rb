# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Position::Connection do
  subject(:position_connection) { build(:position_connection) }

  it { is_expected.to belong_to(:position) }
  it { is_expected.to belong_to(:realm) }
end
