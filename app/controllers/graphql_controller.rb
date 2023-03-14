# frozen_string_literal: true

class GraphqlController < ApplicationController
  # If accessing from outside this domain, nullify the session
  # This allows for outside API access while preventing CSRF attacks,
  # but you'll have to authenticate your user separately
  protect_from_forgery with: :null_session
  before_action :authorize
  attr_reader :current_user, :current_account

  def execute
    MultiTenant.with(current_account) do
      render json: MyTeamChurchApiSchema.execute(
        params[:query],
        variables: prepare_variables(params[:variables] || {}),
        context: { current_account:, current_user: },
        operation_name: params[:operationName]
      )
    end
  rescue StandardError => e
    handle_error(e)
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

  def handle_error(error)
    raise e unless Rails.env.development?

    logger.error error.message
    logger.error error.backtrace.join("\n")

    render json: { errors: [{ message: error.message, backtrace: error.backtrace }], data: {} },
           status: :internal_server_error
  end

  def authorize
    token = request.headers['Authorization']&.split&.last
    return unless token

    decoded_token = JsonWebTokenService.decode(token)
    @current_account = Account.find(decoded_token[:account_id])
    @current_user = @current_account.users.find(decoded_token[:user_id])
  rescue ActiveRecord::RecordNotFound, JWT::DecodeError => e
    render json: { errors: e.message }, status: :unauthorized
  end
end
