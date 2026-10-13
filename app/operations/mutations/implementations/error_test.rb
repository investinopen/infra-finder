# frozen_string_literal: true

module Mutations
  module Implementations
    # @see Mutations::ErrorTest
    class ErrorTest < VOGMutations::Implementation
      use_contract! :error_test

      authorizes! :current_user, with: :test_errors?

      # @param [{ Symbol => Object }] args
      # @return [void]
      def call(**args)
        # simplecov:disable
        attach! :ok, true
        # simplecov:enable
      end
    end
  end
end
