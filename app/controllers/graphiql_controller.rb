# frozen_string_literal: true

# Serves a GraphiQL IDE against {GraphQLController} in development only.
#
# It skips {ApplicationController} to avoid the Devise and terms-acceptance
# filters; the API authenticates with bearer tokens, not the session.
#
# @see config/routes.rb
class GraphiQLController < ActionController::Base # rubocop:disable Rails/ApplicationController
  layout false

  # @return [void]
  def show; end
end
