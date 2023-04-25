# frozen_string_literal: true

module Types
  module Objects
    module Objective
      class ResultType < Types::BaseObject
        graphql_name 'ObjectiveResult'
        description 'result for a objective'
        field :account, Types::Objects::AccountType, 'account record belongs to', null: false
        field :activities, [Types::Objects::Objective::ActivityType], 'activities connected with result',
              null: false
        field :contact, Types::Objects::ContactType, 'contact result belongs to', null: false
        field :created_at, GraphQL::Types::ISO8601DateTime, 'time record created', null: false
        field :current_value, Float, 'current value', null: true
        field :description, String, 'description of result', null: true
        field :due_at, GraphQL::Types::ISO8601Date, 'date result due', null: true
        field :id, ID, 'record unique identifier', null: false
        field :kind, Types::Enums::Objective::Result::KindType, 'kind of result', null: false
        field :measurement, Types::Enums::Objective::Result::MeasurementType, 'measurement to use', null: false
        field :objective, Types::Objects::ObjectiveType, 'objective result belongs to', null: false
        field :percentage, Int, 'current value expressed as a percentage', null: false
        field :progress, Types::Enums::Objective::ProgressType, 'current progress', null: false
        field :start_at, GraphQL::Types::ISO8601Date, 'date result started', null: true
        field :start_value, Float, 'start value', null: false
        field :status, Types::Enums::StatusType, 'record status', null: false
        field :target_value, Float, 'target value', null: false
        field :title, String, 'title of record', null: false
        field :updated_at, GraphQL::Types::ISO8601DateTime, 'time record updated', null: false

        def account
          dataloader.with(::Sources::ActiveRecordService, ::Account).load(object.account_id)
        end

        def contact
          dataloader.with(::Sources::ActiveRecordService, ::Contact).load(object.contact_id)
        end

        def objective
          dataloader.with(::Sources::ActiveRecordService, ::Objective).load(object.objective_id)
        end
      end
    end
  end
end
