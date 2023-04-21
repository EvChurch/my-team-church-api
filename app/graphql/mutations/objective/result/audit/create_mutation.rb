# frozen_string_literal: true

module Mutations
  module Objective
    module Result
      module Audit
        class CreateMutation < Mutations::BaseMutation
          graphql_name 'ObjectiveResultAuditCreateMutation'
          description 'create a audit belonging to a result'

          argument :audit, Types::Inputs::Objective::Result::AuditInputType, 'audit to create', required: true,
                                                                                                as: :attributes

          field :audit, Types::Objects::Objective::Result::AuditType, 'created audit', null: true

          def resolve(attributes:)
            audit = ::Objective::Result::Audit.create(attributes.to_h)
            audit.save!
            { audit: }
          end

          def authorized?(attributes:)
            result = ::Objective::Result.find(attributes[:result_id])
            team_id = result.objective.team_id
            super && context[:current_user].present? && context[:current_user].team_ids.include?(team_id)
          end
        end
      end
    end
  end
end
