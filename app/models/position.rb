# frozen_string_literal: true

class Position < ApplicationRecord
  has_ancestry
  multi_tenant :organization
  validates :title, presence: true
end
