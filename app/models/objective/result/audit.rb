# frozen_string_literal: true

class Objective
  class Result
    class Audit < ApplicationRecord
      multi_tenant :account
      belongs_to :result
      belongs_to :contact
      enum progress: Objective.progresses
      after_commit :update_result, on: :create

      protected

      def update_result
        attributes = { progress:, current_value: }.compact

        result.update(attributes) if hash.present?
      end
    end
  end
end
