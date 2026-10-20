# frozen_string_literal: true

module OAuth
  # Create or update the admin SPA's OAuth application from configuration.
  # Runs on every deploy, because deploys do not run `db:seed`.
  #
  # @see OidcConfig#admin_spa_client_id
  # @see LocationsConfig#admin_spa_home_url
  class SyncApplications
    include Dry::Monads[:result]

    # @return [Dry::Monads::Success(OAuth::Application)]
    # @return [Dry::Monads::Success(nil)] when no admin SPA is configured
    def call
      return Success(nil) unless LocationsConfig.admin_spa?

      application = OAuth::Application.find_or_initialize_by(uid: OidcConfig.admin_spa_client_id)

      home_url = LocationsConfig.admin_spa_home_url

      application.assign_attributes(
        name: "Admin SPA",
        confidential: false,
        redirect_uri: home_url,
        post_logout_redirect_uri: home_url,
        scopes: "openid profile email"
      )

      application.save!

      Success application
    end
  end
end
