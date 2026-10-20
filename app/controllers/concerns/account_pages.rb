# frozen_string_literal: true

# Shared behavior for the Devise account pages (sign-in, password reset,
# confirmation, unlock), which serve the admin SPA's OpenID Connect flow
# and ActiveAdmin. They have their own layout so they can be styled
# separately from the rest of the site.
module AccountPages
  extend ActiveSupport::Concern

  included do
    layout "accounts"
  end

  private

  # Rate limit an action per IP, sending the visitor back to the form.
  #
  # @return [void]
  def rate_limited!
    redirect_back_or_to new_user_session_path, alert: t("devise.failure.rate_limited")
  end

  # The pending `/oauth/authorize` request or ActiveAdmin page, when there is
  # one. Otherwise admins and editors go to the SPA (or ActiveAdmin until it
  # is configured), and everyone else to the public site.
  #
  # @param [User] resource
  # @return [String]
  def after_sign_in_path_for(resource)
    stored_location_for(resource) || default_location_for(resource)
  end

  # @param [User] user
  # @return [String]
  def default_location_for(user)
    if !user.has_any_admin_or_editor_access?
      root_path
    elsif LocationsConfig.admin_spa?
      LocationsConfig.admin_spa
    else
      admin_root_path
    end
  end

  class_methods do
    # @param [Integer] to
    # @param [ActiveSupport::Duration] within
    # @return [void]
    def rate_limit_create!(to:, within:)
      rate_limit to:, within:, only: :create, with: :rate_limited!
    end
  end
end
