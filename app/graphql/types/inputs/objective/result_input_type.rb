# frozen_string_literal: true

module Types
  module Inputs
    module Objective
      class ResultInputType < Types::BaseInputObject
        graphql_name 'ObjectiveResultInput'
        description 'result attributes'

        argument :contact_id, ID, 'lead contact', required: true
        argument :description, String, 'title of result', required: false
        argument :due_at, GraphQL::Types::ISO8601Date, 'date that result is due to complete', required: false
        argument :kind, Types::Enums::Objective::Result::KindType, 'kind of result', required: true
        argument :measurement, Types::Enums::Objective::Result::MeasurementType, 'measurement of result', required: true
        argument :objective_id, ID, 'owner objective', required: true
        argument :start_at, GraphQL::Types::ISO8601Date, 'date that result is starting', required: false
        argument :start_value, Float, 'start value', required: true
        argument :status, Types::Enums::StatusType, 'status of result', required: true
        argument :target_value, Float, 'target value', required: true
        argument :title, String, 'title of result', required: true
      end
    end
  end
end
