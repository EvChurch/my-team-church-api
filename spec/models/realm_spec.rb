# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Realm do
  subject(:realm) { build(:realm) }

  it { is_expected.to validate_presence_of(:title) }
end
