# frozen_string_literal: true

Doorkeeper::OpenidConnect.configure do
  issuer { LocationsConfig.root }

  signing_key { OidcConfig.signing_key_pem }

  subject_types_supported [:public]

  # The gem defaults to http outside of the production environment.
  protocol { URI(LocationsConfig.root).scheme.to_sym }

  # Advertise the issuer's host, not the host of the discovery request.
  discovery_url_options do |_request|
    %i[authorization token revocation introspection userinfo jwks].index_with { LocationsConfig.root_url_options }
  end

  end_session_endpoint { oauth_logout_url(**LocationsConfig.root_url_options) }

  expiration 1.hour.to_i

  resource_owner_from_access_token do |access_token|
    User.find_by(id: access_token.resource_owner_id)
  end

  auth_time_from_resource_owner { |user| user.current_sign_in_at }

  # `prompt=login`
  reauthenticate_resource_owner do |_user, return_to|
    # Re-entering a password is not a sign-out, so token sessions stay.
    request.env[User::KEEP_TOKEN_SESSIONS] = true

    sign_out(:user)

    store_location_for(:user, return_to)

    redirect_to new_user_session_url
  end

  # `prompt=select_account` is not supported: doing nothing makes the request
  # fail with `account_selection_required`.
  select_account_for_resource_owner { |*| nil }

  subject { |user, _application| user.id }

  claims do
    normal_claim(:email, scope: :email, response: %i[id_token user_info]) { |user| user.email }

    normal_claim(:email_verified, scope: :email, response: %i[id_token user_info]) { |user| user.confirmed? }

    normal_claim(:name, scope: :profile, response: %i[id_token user_info]) { |user| user.name }
  end
end
