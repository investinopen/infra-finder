# frozen_string_literal: true

module OAuth
  # A client of the OpenID Provider. Every application is first-party.
  #
  # @see OAuth::SyncApplications
  class Application < ApplicationRecord
    include ::Doorkeeper::Orm::ActiveRecord::Mixins::Application

    # @param [String, nil] uri
    # @return [Boolean]
    def post_logout_redirect_uri?(uri)
      uri.present? && post_logout_redirect_uri.split.include?(uri)
    end
  end
end
