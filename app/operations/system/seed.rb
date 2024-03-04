# frozen_string_literal: true

module System
  # An operation that is called on every release,
  # _after_ {System::ReloadEverything}, and ensures that models
  # are seeded.
  #
  # The records loaded by this operation should _not_ be required for testing,
  # but should always exist in production and staging environments.
  #
  # @api private
  class Seed
    include Dry::Monads[:result, :do]

    # @return [Dry::Monads::Result]
    def call
      Success()
    end
  end
end
