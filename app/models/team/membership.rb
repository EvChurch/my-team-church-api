# frozen_string_literal: true

class Team
  class Membership < ApplicationRecord
    multi_tenant :account
    belongs_to :contact
    belongs_to :team
    validates :team_id, uniqueness: { scope: %i[contact_id] }
  end
end
