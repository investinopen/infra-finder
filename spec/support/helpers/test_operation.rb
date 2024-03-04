# frozen_string_literal: true

module TestHelpers
  # A pseudo-interface for an operation, to be used with mocks
  # @abstract
  class TestOperation
    # @return [Dry::Monads::Result]
    def call(*)
      ::Dry::Monads.Success()
    end
  end
end
