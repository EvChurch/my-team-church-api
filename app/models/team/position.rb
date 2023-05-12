# frozen_string_literal: true

class Team
  class Position < ApplicationRecord
    extend FriendlyId
    friendly_id :friendly_id_title, use: :scoped, scope: %i[account_id team_id]
    multi_tenant :account
    belongs_to :team
    has_many :assignments, dependent: :delete_all
    has_many :contacts, through: :assignments
    validates :title, presence: true
    validates :remote_id, uniqueness: { scope: %i[account_id team_id] }, allow_nil: true

    def should_generate_new_friendly_id?
      title_changed?
    end

    def friendly_id_title
      case title&.parameterize
      when 'admin' then 'administrator'
      else title
      end
    end
  end
end
