# frozen_string_literal: true

module Utility
  # An error raised when any subclass of {ApplicationJob} should be halted and discarded.
  # @api private
  class HaltedJobError < StandardError; end
end
