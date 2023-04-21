# frozen_string_literal: true

module Types
  module Inputs
    module Objective
      module Result
        class AuditInputType < Types::BaseInputObject
          graphql_name 'ObjectiveResultAuditInput'
          description 'audit attributes'

          argument :comment, String, 'comment', required: false
          argument :contact_id, ID, 'lead contact', required: true
          argument :current_value, Float, 'start value', required: true
          argument :progress, Types::Enums::Objective::ProgressType, 'progress of audit',
                   required: true
          argument :result_id, ID, 'owner result', required: true
        end
      end
    end
  end
end
