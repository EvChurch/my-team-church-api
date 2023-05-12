# frozen_string_literal: true

class Team
  class Assignment < ApplicationRecord
    multi_tenant :account
    belongs_to :position
    belongs_to :contact
    validates :position_id, uniqueness: { scope: %i[contact_id] }
  end
end
