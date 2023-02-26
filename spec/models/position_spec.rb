# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Position do
  subject(:position) { build(:position) }

  it { is_expected.to validate_presence_of(:title) }
end
