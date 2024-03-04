# frozen_string_literal: true

module System
  # An operation to set up initial records that should always exist in production,
  # but may be edited after this is run. Contrast with `System::Seed`, which will
  # be run on every release.
  #
  # @api private
  class InitialSeed
    include Dry::Monads[:result, :do]

    include InfraFinder::Deps[
      seed_all_options: "seeding.seed_all_options",
    ]

    # @return [Dry::Monads::Result]
    def call
      yield seed_all_options.()

      Success()
    end
  end
end
