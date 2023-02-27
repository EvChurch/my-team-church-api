# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Realm do
  subject(:realm) { create(:realm) }

  it { is_expected.to have_many(:connections).dependent(:delete_all) }
  it { is_expected.to have_many(:contacts).through(:connections) }
  it { is_expected.to have_many(:teams).through(:connections) }
  it { is_expected.to validate_presence_of(:title) }
end
