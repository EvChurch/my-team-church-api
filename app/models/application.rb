class Application < ApplicationRecord
  extend FriendlyId
  friendly_id :title, use: :scoped, scope: [:account_id]
  multi_tenant :account
end
