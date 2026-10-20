# frozen_string_literal: true

module OAuth
  # An access token and its refresh token. Every token in a token session
  # shares a `session_id`: the first is created from an authorization code,
  # and Doorkeeper copies the session onto each token created by a refresh.
  class AccessToken < ApplicationRecord
    include ::Doorkeeper::Orm::ActiveRecord::Mixins::AccessToken

    # How long a token session may be refreshed for, matching `Devise.remember_for`.
    SESSION_LIFETIME = 30.days

    before_validation :start_session!, on: :create

    scope :active, -> { where(revoked_at: nil) }
    scope :in_session, ->(session_id) { where(session_id:) }
    scope :session_ended, -> { where(session_started_at: ...SESSION_LIFETIME.ago) }

    # @return [Boolean]
    def session_ended?
      session_started_at <= SESSION_LIFETIME.ago
    end

    private

    # @return [void]
    def start_session!
      self.session_id ||= SecureRandom.uuid
      self.session_started_at ||= Time.current
    end

    class << self
      # Refreshing fails once the token session is too old.
      #
      # @param [String] refresh_token
      # @return [OAuth::AccessToken, nil]
      def by_refresh_token(refresh_token)
        token = super

        token unless token&.session_ended?
      end

      # @param [User] user
      # @param [String, nil] session_id
      # @return [Boolean]
      def session_active?(user, session_id)
        return false if session_id.blank?

        active.in_session(session_id).exists?(resource_owner_id: user.id, session_started_at: SESSION_LIFETIME.ago..)
      end

      # @param [User] user
      # @return [void]
      def revoke_all_for_user(user)
        active.where(resource_owner_id: user.id).update_all(revoked_at: Time.current)
      end
    end
  end
end
