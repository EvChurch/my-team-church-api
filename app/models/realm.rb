# frozen_string_literal: true

class Realm < ApplicationRecord
  has_ancestry
  multi_tenant :organization
  validates :title, presence: true
end
