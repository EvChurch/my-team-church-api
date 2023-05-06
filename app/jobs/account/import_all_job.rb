# frozen_string_literal: true

class Account
  class ImportAllJob < ApplicationJob
    queue_as :default

    def perform(api_key)
      Account.import_all(api_key)
    end
  end
end
