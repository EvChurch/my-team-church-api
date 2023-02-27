# frozen_string_literal: true

class Contact
  class Membership < ApplicationRecord
    multi_tenant :organization
    belongs_to :contact
    belongs_to :team
    validates :contact_id, uniqueness: { scope: :team_id }
  end
end
