# frozen_string_literal: true

# Request handling for the GraphQL API.
#
# It inherits from `ActionController::API` rather than {ApplicationController}
# so that the API never touches cookies, sessions, or CSRF protection.
class GraphQLController < ActionController::API
  include OperationHelpers

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
      request_state:,
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
