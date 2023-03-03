# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Application do
  subject(:application) { create(:application) }

  it { is_expected.to validate_presence_of(:title) }
  it { is_expected.to validate_presence_of(:definition) }
  it { is_expected.to validate_uniqueness_of(:remote_id).scoped_to(:account_id).allow_nil }
end
