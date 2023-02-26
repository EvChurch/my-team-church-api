# frozen_string_literal: true

class Contact
  class Connection < ApplicationRecord
    multi_tenant :organization
    belongs_to :contact
    belongs_to :realm
    validates :contact_id, uniqueness: { scope: :realm_id }
  end
end
