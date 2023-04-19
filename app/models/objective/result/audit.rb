# frozen_string_literal: true

class Objective
  class Result
    class Audit < ApplicationRecord
      multi_tenant :account
      belongs_to :result
      belongs_to :contact
      enum progress: Objective.progresses
      validates :current_value, :progress, presence: true
      after_commit :update_result, on: :create

      protected

      def update_result
        result.update(progress:, current_value:)
      end
    end
  end
end
