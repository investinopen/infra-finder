# frozen_string_literal: true

module StoredMessages
  # A custom formatter that supports tagging used by {StoredMessages::Logger}.
  #
  # @api private
  class Formatter
    include ActiveSupport::TaggedLogging::Formatter

    # A tie-breaker counter that is used to make sure that messages that came in at the same
    # time can still be sorted in proper reverse insertion order.
    #
    # @api private
    # @return [Integer]
    attr_reader :q

    def initialize
      @q = 0
    end

    # @param [StoredMessages::Types::Level] severity
    # @param [Time] at
    # @param [String, nil] step (aka `progname`)
    # @param [String] message
    # @return [StoredMessages::Message]
    def call(severity, at, step, message)
      level = StoredMessages::Types::Level[severity.to_s.underscore]

      tags = tag_stack.tags.dup.freeze

      StoredMessages::Message.new(level:, at:, step:, message:, tags:, q:)
    ensure
      @q += 1
    end
  end
end
