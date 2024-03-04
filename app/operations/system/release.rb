# frozen_string_literal: true

module System
  # The task that runs on each release, and calls
  # other operations within the {System} namespace.
  class Release
    include Dry::Monads[:result, :do]
    include Common::Deps[
      pause_job_processing: "system.pause_job_processing",
      reload_everything: "system.reload_everything",
      seed: "system.seed",
    ]

    # @return [Dry::Monads::Result]
    def call
      yield pause_job_processing.()
      yield reload_everything.()
      yield seed.()

      Success()
    end
  end
end
