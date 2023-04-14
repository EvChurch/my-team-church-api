# frozen_string_literal: true

class Objective < ApplicationRecord
  multi_tenant :account
  belongs_to :objectable, polymorphic: true
  enum status: { active: 'active', archived: 'archived', draft: 'draft' }
  validates :title, presence: true
end
