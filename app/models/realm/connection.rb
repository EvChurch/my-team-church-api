# frozen_string_literal: true

class Realm
  class Connection < ApplicationRecord
    multi_tenant :organization
    belongs_to :realm
    belongs_to :subject, polymorphic: true
  end
end
