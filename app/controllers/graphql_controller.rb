# frozen_string_literal: true

# Request handling for the GraphQL API.
#
# It inherits from `ActionController::API` rather than {ApplicationController}
# so that the API never touches cookies, sessions, or CSRF protection.
class GraphQLController < ActionController::API
  include OperationHelpers

  before_action :attach_request_id!
  before_action :authenticate_user!

  # This method handles all GraphQL requests that the API receives.
  #
  # @see APISchema
  # @return [void]
  def execute
    variables = prepare_variables(params[:variables])

    query = params[:query]

    operation_name = params[:operationName]

    request_state = Support::Requests::State.new

    context = {
      current_user: @current_user,
      request_ip: request.remote_ip,
      request_state:,
      token_payload: @token_payload,
    }

    json = request_state.wrap do
      APISchema.execute(query, variables:, context:, operation_name:, validate: SystemConfig.validate_graphql_query?)
    end

    render(json:)
  rescue StandardError => e
    # simplecov:disable
    raise e unless Rails.env.development?

    handle_error_in_development e
    # simplecov:enable
  end

  private

  # @return [void]
  def attach_request_id!
    Support::Requests::Current.request_id = request.request_id
  end

  # {#perform_operation Perform} the {Users::Authenticate authenticate operation}
  # for the current request.
  #
  # @return [void]
  def authenticate_user!
    perform_operation "users.authenticate", request.env do |m|
      m.success do |(user, payload)|
        Support::Requests::Current.current_user = user

        @current_user = user
        @token_payload = payload
      end

      m.failure(:expired) do
        render_server_message! "tokens.expired", status: :unauthorized
      end

      m.failure(:inactive) do
        render_server_message! "tokens.inactive", status: :forbidden
      end

      m.failure do
        render_server_message! "tokens.invalid", status: :unauthorized
      end
    end
  end

  # Render a standard, localized server error in the format favored by GraphQL clients.
  #
  # @param [#to_s] key an i18n key in the `server_messages` namespace.
  # @param [Symbol, Integer] status
  # @return [void]
  def render_server_message!(key, status:)
    render json: { errors: [{ message: I18n.t(key, scope: "server_messages") }] }, status:
  end

  # Handle variables in form data, JSON body, or a blank value
  #
  # @param [String, Hash, ActionController::Parameters] variables_param
  # @return [Hash]
  def prepare_variables(variables_param)
    # simplecov:disable
    case variables_param
    when String
      if variables_param.present?
        JSON.parse(variables_param) || {}
      else
        {}
      end
    when Hash
      variables_param
    when ActionController::Parameters
      variables_param.to_unsafe_hash # GraphQL-Ruby will validate name and type of incoming variables.
    when nil
      {}
    else
      raise ArgumentError, "Unexpected parameter: #{variables_param}"
    end
    # simplecov:enable
  end

  # Render a backtrace for errors that occur in development.
  #
  # @param [Exception] err
  # @return [void]
  def handle_error_in_development(err)
    # simplecov:disable
    logger.error err.message
    logger.error err.backtrace.join("\n")

    render json: { errors: [{ message: err.message, backtrace: err.backtrace }], data: {} }, status: :internal_server_error
    # simplecov:enable
  end
end
