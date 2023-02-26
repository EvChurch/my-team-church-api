# frozen_string_literal: true

class Position
  class Connection < ApplicationRecord
    multi_tenant :organization
    belongs_to :position
    belongs_to :realm
    validates :position_id, uniqueness: { scope: :realm_id }
  end
end
