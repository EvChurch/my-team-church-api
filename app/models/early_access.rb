# frozen_string_literal: true

class EarlyAccess < ApplicationRecord
  validates :first_name, presence: true
  validates :email_address, presence: true, uniqueness: { case_sensitive: false }
end
