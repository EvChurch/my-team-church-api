# frozen_string_literal: true

module Mutations
  module EarlyAccess
    class CreateMutation < Mutations::BaseMutation
      graphql_name 'EarlyAccessCreateMutation'
      description 'create an early access request'

      argument :early_access, Types::Inputs::EarlyAccessInputType, 'early access request to create', required: true,
                                                                                                     as: :attributes

      field :early_access, Types::Objects::EarlyAccessType, 'created early access request', null: true

      def resolve(attributes:)
        early_access = ::EarlyAccess.create(attributes.to_h)
        early_access.save!
        { early_access: }
      end
    end
  end
end
