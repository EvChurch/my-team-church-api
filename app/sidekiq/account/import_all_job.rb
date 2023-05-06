# frozen_string_literal: true

class Account
  class ImportAllJob
    include Sidekiq::Job

    def perform(api_key)
      Account.import_all(api_key)
    end
  end
end
