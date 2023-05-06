# frozen_string_literal: true

class Application
  class ImportJob < ApplicationJob
    queue_as :default

    def perform(id)
      Application.find_by(id:)&.import
    end
  end
end
