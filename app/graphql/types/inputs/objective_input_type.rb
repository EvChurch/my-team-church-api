# frozen_string_literal: true

module Types
  module Inputs
    class ObjectiveInputType < Types::BaseInputObject
      description 'objective attributes'

      argument :contact_id, ID, 'lead contact', required: true
      argument :description, String, 'title of objective', required: false
      argument :due_at, GraphQL::Types::ISO8601Date, 'date that objective is due to complete', required: true
      argument :status, Types::Enums::StatusType, 'status of objective', required: true
      argument :team_id, ID, 'owner team', required: true
      argument :title, String, 'title of objective', required: true
    end
  end
end
