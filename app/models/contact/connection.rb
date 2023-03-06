# frozen_string_literal: true

class Contact
  class Connection < ApplicationRecord
    multi_tenant :account
    belongs_to :contact
    belongs_to :user
    validates :user_id, uniqueness: { scope: %i[contact_id] }
  end
end
