# frozen_string_literal: true

class Team
  class Connection < ApplicationRecord
    multi_tenant :organization
    belongs_to :team
    belongs_to :realm
    validates :team_id, uniqueness: { scope: :realm_id }
  end
end
