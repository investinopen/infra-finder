# frozen_string_literal: true

# Serves a GraphiQL IDE against {GraphQLController} in development only.
#
# It skips {ApplicationController} to avoid the Devise and terms-acceptance
# filters; the API authenticates with bearer tokens, not the session.
# When a user is signed in, it mints an access token for them so that
# GraphiQL's requests are authenticated; otherwise it runs anonymously.
#
# @see config/routes.rb
class GraphiQLController < ActionController::Base # rubocop:disable Rails/ApplicationController
  layout false

  # @return [void]
  def show
    if current_user.present?
      @access_token = mint_access_token
    else
      store_location_for(:user, graphiql_path)
    end
  end

  private

  # A new token on every load, because hashed tokens cannot be read back.
  #
  # @return [String]
  def mint_access_token
    application = OAuth::Application.find_or_create_by!(uid: "graphiql") do |app|
      app.name = "GraphiQL"
      app.confidential = false
      app.redirect_uri = graphiql_url
      app.scopes = "openid profile email"
    end

    OAuth::AccessToken.create!(
      resource_owner_id: current_user.id,
      application:,
      scopes: "openid profile email",
      expires_in: Doorkeeper.config.access_token_expires_in
    ).plaintext_token
  end
end
