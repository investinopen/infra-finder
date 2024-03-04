# frozen_string_literal: true

module System
  # An operation that is called on every release,
  # as well as before every test run.
  #
  # @api private
  class ReloadEverything
    include Dry::Monads[:do, :result]

    # @return [Dry::Monads::Result]
    def call
      Success()
    end
  end
end
