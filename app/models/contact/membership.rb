# frozen_string_literal: true

class Contact
  class Membership < ApplicationRecord
    multi_tenant :organization
    belongs_to :contact
    belongs_to :position
    validates :contact_id, uniqueness: { scope: :position_id }
  end
end
