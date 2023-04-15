# frozen_string_literal: true

class Objective < ApplicationRecord
  multi_tenant :account
  belongs_to :team
  belongs_to :contact
  enum status: { active: 'active', archived: 'archived', draft: 'draft' }
  validates :title, presence: true
end
