# frozen_string_literal: true

module Types
  module Objects
    module Objective
      class ActivityType < Types::BaseObject
        description 'activity for an objective'
        field :account, Types::Objects::AccountType, 'account record belongs to', null: false
        field :comment, String, 'comment on activity', null: false
        field :contact, Types::Objects::ContactType, 'contact activity belongs to', null: false
        field :created_at, GraphQL::Types::ISO8601DateTime, 'time record created', null: false
        field :current_value, Float, 'current value', null: false
        field :id, ID, 'record unique identifier', null: false
        field :kind, Types::Enums::Objective::Activity::KindType, 'kind of activity', null: false
        field :objective, Types::Objects::ObjectiveType, 'objective activity belongs to', null: false
        field :progress, Types::Enums::Objective::ProgressType, 'current progress', null: false
        field :result, Types::Objects::Objective::ResultType, 'result activity updated', null: false
        field :updated_at, GraphQL::Types::ISO8601DateTime, 'time record updated', null: false

        def account
          dataloader.with(::Sources::ActiveRecordService, ::Account).load(object.account_id)
        end

        def contact
          dataloader.with(::Sources::ActiveRecordService, ::Contact).load(object.contact_id)
        end

        def result
          dataloader.with(::Sources::ActiveRecordService, ::Objective::Result).load(object.result_id)
        end
      end
    end
  end
end
