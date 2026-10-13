# frozen_string_literal: true

module Users
  # A fixed-window, per-IP throttle for the unauthenticated auth mutations.
  #
  # Rails' controller-level `rate_limit` cannot target individual mutations
  # on the single `/graphql` endpoint, so the mutations check this directly.
  module Throttle
    # Attempts allowed per window, keyed by action.
    LIMITS = {
      sign_in: [10, 5.minutes],
      password_reset: [5, 1.hour],
      confirmation: [5, 1.hour],
    }.freeze

    class << self
      # Record an attempt and report whether the limit is now exceeded.
      #
      # @param [Symbol] action a key in {LIMITS}
      # @param [String, nil] ip
      # @return [Boolean]
      def exceeded?(action, ip)
        limit, period = LIMITS.fetch(action)

        # The window is part of the key so the count resets even if the
        # cache store ignores `expires_in`.
        window = Time.current.to_i / period.to_i

        key = "users/throttle/#{action}/#{ip}/#{window}"

        Rails.cache.increment(key, 1, expires_in: period).to_i > limit
      end
    end
  end
end
