# frozen_string_literal: true

module Comparisons
  # Fetch (find or create) a {Comparison} for the given request parameters.
  #
  # @see Comparisons::Fetcher
  class Fetcher < Support::HookBased::Actor
    include Dry::Initializer[undefined: false].define -> do
      option :session_id, Utility::Types::SessionID.optional
      option :ip, Types::String.optional, optional: true
    end

    include MonadicPersistence

    standard_execution!

    # @return [Comparison]
    attr_reader :comparison

    def call
      run_callbacks :execute do
        yield fetch_for_session!

        yield track!
      end

      Success comparison
    end

    wrapped_hook! def fetch_for_session
      return Failure[:no_session] if session_id.blank?

      @comparison = Comparison.where(session_id:).first_or_initialize do |cmp|
        cmp.assign_attributes(ip:)
      end

      yield monadic_save @comparison

      super
    end

    wrapped_hook! def track
      comparison.touch(:last_seen_at)
    end
  end
end
