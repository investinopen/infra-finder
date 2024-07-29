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
      upsert_all_records: "controlled_vocabularies.upsert_all_records",
    ]

    # @return [Dry::Monads::Result]
    def call
      yield upsert_all_records.()

      Success()
    end
  end
end
