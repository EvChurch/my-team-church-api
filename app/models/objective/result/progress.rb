class Objective
  class Result
    class Progress < ApplicationRecord
      multi_tenant :account
      belongs_to :result
      belongs_to :contact
      enum progress: Objective::Result.progresses
      validates :current_value, :progress, presence: true
      after_commit :update_result, on: :create

      protected

      def update_result
        result.update(progress:, current_value:)
      end
    end
  end
end
