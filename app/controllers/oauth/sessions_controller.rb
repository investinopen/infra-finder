# frozen_string_literal: true

module OAuth
  # RP-initiated logout, advertised as the `end_session_endpoint`.
  #
  # A valid `id_token_hint` is required, so a link elsewhere cannot sign
  # users out. Signing out revokes the user's token sessions on every device
  # (see the Warden hook in `config/initializers/devise.rb`).
  class SessionsController < ApplicationController
    # `GET /oauth/logout`
    #
    # @return [void]
    def destroy
      claims = decode_id_token_hint

      application = OAuth::Application.find_by(uid: claims&.fetch("aud", nil))

      return render(plain: t(".invalid"), status: :bad_request) if application.nil? || client_mismatch?(application)

      User.find_by(id: claims["sub"])&.revoke_token_sessions!

      sign_out(:user)

      redirect_to post_logout_location_for(application), allow_other_host: true
    end

    private

    # @param [OAuth::Application] application
    # @return [Boolean]
    def client_mismatch?(application)
      params[:client_id].present? && params[:client_id] != application.uid
    end

    # The ID token may have expired; the signature and issuer are what matter here.
    #
    # @return [Hash, nil]
    def decode_id_token_hint
      return if params[:id_token_hint].blank?

      key = Doorkeeper::OpenidConnect.signing_key.verify_key

      payload, = JWT.decode(
        params[:id_token_hint], key, true,
        algorithm: "RS256", verify_expiration: false, iss: LocationsConfig.root, verify_iss: true
      )

      payload
    rescue JWT::DecodeError
      nil
    end

    # @param [OAuth::Application] application
    # @return [String]
    def post_logout_location_for(application)
      uri = params[:post_logout_redirect_uri]

      return new_user_session_url unless application.post_logout_redirect_uri?(uri)

      return uri if params[:state].blank?

      URI(uri).tap do |u|
        u.query = [u.query, { state: params[:state] }.to_query].compact_blank.join("&")
      end.to_s
    end
  end
end
