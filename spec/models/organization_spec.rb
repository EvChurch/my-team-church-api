# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Organization do
  subject(:organization) { create(:organization) }

  it { is_expected.to have_many(:contacts).dependent(:delete_all) }
  it { is_expected.to have_many(:realms).dependent(:delete_all) }
  it { is_expected.to have_many(:teams).dependent(:delete_all) }
  it { is_expected.to validate_presence_of(:title) }
end
