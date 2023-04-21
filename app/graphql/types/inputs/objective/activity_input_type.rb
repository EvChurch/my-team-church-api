# frozen_string_literal: true

module Types
  module Inputs
    module Objective
      class ActivityInputType < Types::BaseInputObject
        graphql_name 'ObjectiveResultactivityInput'
        description 'activity attributes'

        argument :comment, String, 'comment', required: false
        argument :contact_id, ID, 'lead contact', required: true
        argument :current_value, Float,
                 'start value (only applies if resultId present and kind is update)',
                 required: false
        argument :kind, Types::Enums::Objective::Activity::KindType, 'kind of activity', required: true
        argument :objective_id, ID, 'owner objective', required: true
        argument :progress, Types::Enums::Objective::ProgressType,
                 'progress of activity (resultId present and kind progress_update)',
                 required: false
        argument :result_id, ID, 'result to update', required: false
      end
    end
  end
end
