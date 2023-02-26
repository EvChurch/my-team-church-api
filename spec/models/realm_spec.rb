# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Realm do
  subject(:realm) { build(:realm) }

  it { is_expected.to have_many(:contact_connections).dependent(:delete_all) }
  it { is_expected.to have_many(:contacts).through(:contact_connections) }
  it { is_expected.to have_many(:position_connections).dependent(:delete_all) }
  it { is_expected.to have_many(:positions).through(:position_connections) }
  it { is_expected.to validate_presence_of(:title) }
end
