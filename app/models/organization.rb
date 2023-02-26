# frozen_string_literal: true

class Organization < ApplicationRecord
  has_many :realms, dependent: :delete_all
  validates :title, presence: true
end
