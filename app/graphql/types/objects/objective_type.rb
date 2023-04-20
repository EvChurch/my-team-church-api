# frozen_string_literal: true

module Types
  module Objects
    class ObjectiveType < Types::BaseObject
      description 'objective for a team'
      field :account, Types::Objects::AccountType, 'account record belongs to', null: false
      field :audits, [Types::Objects::Objective::Result::AuditType], 'audits connected with results of objective',
            null: false
      field :contact, Types::Objects::ContactType, 'contact objective belongs to', null: false
      field :created_at, GraphQL::Types::ISO8601DateTime, 'time record created', null: false
      field :description, String, 'description of objective', null: true
      field :due_at, GraphQL::Types::ISO8601Date, 'date objective due', null: false
      field :id, ID, 'record unique identifier', null: false
      field :progress, Types::Enums::Objective::ProgressType, 'current progress', null: false
      field :results, [Types::Objects::Objective::ResultType], 'results contributing to objective', null: false
      field :status, Types::Enums::StatusType, 'record status'
      field :team, Types::Objects::TeamType, 'team objective belongs to', null: false
      field :title, String, 'title of record', null: false
      field :updated_at, GraphQL::Types::ISO8601DateTime, 'time record updated', null: false

      def account
        dataloader.with(::Sources::ActiveRecordService, ::Account).load(object.account_id)
      end

      def contact
        dataloader.with(::Sources::ActiveRecordService, ::Contact).load(object.contact_id)
      end

      def team
        dataloader.with(::Sources::ActiveRecordService, ::Team).load(object.team_id)
      end
    end
  end
end
