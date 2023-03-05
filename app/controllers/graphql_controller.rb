# frozen_string_literal: true

class GraphqlController < ApplicationController
  # If accessing from outside this domain, nullify the session
  # This allows for outside API access while preventing CSRF attacks,
  # but you'll have to authenticate your user separately
  protect_from_forgery with: :null_session

  def execute
    variables = prepare_variables(params[:variables] || {})
    operation_name = params[:operationName]
    MultiTenant.with(current_account) do
      context = {
        # Query context goes here, for example:
        current_account:
        # current_user:
      }
      render json: MyTeamChurchApiSchema.execute(params[:query], variables:, context:, operation_name:)
    end
  rescue StandardError => e
    raise e unless Rails.env.development?

    handle_error_in_development(e)
  end

  private

  # Handle variables in form data, JSON body, or a blank value
  def prepare_variables(variables_param)
    case variables_param
    when String
      return variables_param.present? ? JSON.parse(variables_param) || {} : {}
    when Hash
      return variables_param
    when ActionController::Parameters
      return variables_param.to_unsafe_hash # GraphQL-Ruby will validate name and type of incoming variables.
    end
    raise ArgumentError, "Unexpected parameter: #{variables_param}"
  end

  def handle_error_in_development(error)
    logger.error error.message
    logger.error error.backtrace.join("\n")

    render json: { errors: [{ message: error.message, backtrace: error.backtrace }], data: {} },
           status: :internal_server_error
  end

  def current_account
    Account.friendly.find(request.headers['X-ACCOUNT-ID'])
  end
end
