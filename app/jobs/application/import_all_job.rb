# frozen_string_literal: true

class Application
  class ImportAllJob < ApplicationJob
    queue_as :default

    def perform
      Application.find_each do |application|
        Application::ImportJob.perform_later(application.id)
      end
    end
  end
end
