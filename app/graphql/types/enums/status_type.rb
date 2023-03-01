# frozen_string_literal: true

module Types
  module Enums
    class StatusType < Types::BaseEnum
      description 'record status enum'

      value 'active'
      value 'archived'
      value 'draft'
    end
  end
end
