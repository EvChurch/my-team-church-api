# frozen_string_literal: true

class Team
  class Membership < ApplicationRecord
    multi_tenant :organization
    belongs_to :contact
    belongs_to :team
  end
end
