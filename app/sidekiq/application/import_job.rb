# frozen_string_literal: true

class Application
  class ImportJob
    include Sidekiq::Job
    sidekiq_options lock: :until_executed

    def perform(id)
      Application.find_by(id:)&.import
    end
  end
end
