# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Organization do
  subject(:organization) { build(:organization) }

  it { is_expected.to have_many(:contacts).dependent(:delete_all) }
  it { is_expected.to have_many(:realms).dependent(:delete_all) }
  it { is_expected.to validate_presence_of(:title) }
end
