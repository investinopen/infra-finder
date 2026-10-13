# frozen_string_literal: true

module VOGMutations
  module Testing
    # A barebones implementation that simply attaches any given args to its outgoing response.
    #
    # @api private
    # @note Only used for testing purposes.
    class PassthroughImplementation < VOGMutations::Implementation
      # @return [void]
      def call(**args)
        attach_many!(**args)
      end
    end
  end
end
