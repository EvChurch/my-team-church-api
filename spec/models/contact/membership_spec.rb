# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Contact::Membership do
  subject(:contact_membership) { build(:contact_membership) }

  it { is_expected.to belong_to(:contact) }
  it { is_expected.to belong_to(:team) }
end
