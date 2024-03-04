# frozen_string_literal: true

module System
  # During the release process, we want to prevent our job processing
  # from running any new jobs that might fire off as a result
  # of our release tasks, or coincide with scheduled work that
  # fires as the release is happening.
  class PauseJobProcessing
    include Dry::Monads[:result]

    # @return [Dry::Monads::Result]
    def call
      Success()
    end
  end
end
