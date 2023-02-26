# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Contact::Connection do
  subject(:contact_connection) { build(:contact_connection) }

  it { is_expected.to belong_to(:contact) }
  it { is_expected.to belong_to(:realm) }
end
