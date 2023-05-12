# frozen_string_literal: true

class Team
  class Position < ApplicationRecord
    extend FriendlyId
    friendly_id :title, use: :scoped, scope: [:account_id]
    multi_tenant :account
    belongs_to :team
    has_many :assignments, dependent: :delete_all
    validates :title, presence: true
    validates :remote_id, uniqueness: { scope: :account_id }, allow_nil: true

    def should_generate_new_friendly_id?
      title_changed?
    end
  end
end
