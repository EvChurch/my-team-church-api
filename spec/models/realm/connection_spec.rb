# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Realm::Connection do
  subject(:realm_connection) { create(:realm_connection) }

  it { is_expected.to belong_to(:realm) }
  it { is_expected.to belong_to(:subject) }
end
