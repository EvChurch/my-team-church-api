# frozen_string_literal: true

class Team < ApplicationRecord
  extend FriendlyId
  friendly_id :friendly_id_title, use: :scoped, scope: [:account_id]
  has_ancestry primary_key_format: %r{\A[\w-]+(/[\w-]+)*\z}
  multi_tenant :account
  has_many :realm_connections,
           dependent: :delete_all,
           class_name: 'Realm::Connection',
           as: :subject
  has_many :realms, through: :realm_connections
  has_many :memberships,
           dependent: :delete_all,
           class_name: 'Team::Membership'
  has_many :contacts, through: :memberships
  has_many :objectives, dependent: :delete_all
  has_many :positions, dependent: :delete_all
  has_many :assignments, through: :positions
  enum progress: Objective.progresses
  enum status: { active: 'active', archived: 'archived', draft: 'draft' }
  validates :title, :definition, presence: true
  validates :remote_id, uniqueness: { scope: :account_id }, allow_nil: true
  before_save :update_summary

  def should_generate_new_friendly_id?
    title_changed?
  end

  def friendly_id_title
    case title&.parameterize
    when 'admin' then 'administrator'
    else title
    end
  end

  def update_summary
    active_objectives = objectives.active.to_a
    update_percentage(active_objectives)
    update_progress(active_objectives)
  end

  def update_percentage(objectives)
    self.percentage = if objectives.empty?
                        0
                      else
                        objectives.sum(&:percentage) / objectives.size
                      end
  end

  def update_progress(objectives)
    self.progress = objectives.pluck(:progress)
                              .reject { |v| v == Objective.progresses[:no_status] }
                              .min_by { |v| Objective.progresses.values.find_index(v) } ||
                    Objective.progresses[:no_status]
  end
end
