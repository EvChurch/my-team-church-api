# frozen_string_literal: true

module Types
  module Inputs
    class EarlyAccessInputType < Types::BaseInputObject
      description 'early access attributes'

      argument :email_address, String, 'email address of interested person', required: true
      argument :first_name, String, 'first name of interested person', required: true
    end
  end
end
