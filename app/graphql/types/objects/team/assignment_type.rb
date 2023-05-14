# frozen_string_literal: true

module Types
  module Objects
    module Team
      class AssignmentType < Types::BaseObject
        description 'assignment to a position on a team'
        field :contact, Types::Objects::ContactType, 'contact connected with this assignment', null: false
        field :created_at, GraphQL::Types::ISO8601DateTime, 'time record created', null: false
        field :id, ID, 'record unique identifier', null: false
        field :position, Types::Objects::Team::PositionType, 'position connected with this assignment', null: false
        field :progress, Types::Enums::Objective::ProgressType, 'current progress (excludes accomplished)', null: false
        field :updated_at, GraphQL::Types::ISO8601DateTime, 'time record updated', null: false

        def contact
          dataloader.with(::Sources::ActiveRecordService, ::Contact).load(object.contact_id)
        end

        def position
          dataloader.with(::Sources::ActiveRecordService, ::Team::Position).load(object.position_id)
        end
      end
    end
  end
end
