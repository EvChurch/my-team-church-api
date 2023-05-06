# frozen_string_literal: true

class Application
  class ImportAllJob
    include Sidekiq::Job

    def perform
      Application.find_each do |application|
        Application::ImportJob.perform_async(application.id)
      end
    end
  end
end
