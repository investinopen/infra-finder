# frozen_string_literal: true

module AllowlistedJwts
  # Prune allowlisted API tokens that have expired.
  class PruneJob < ApplicationJob
    queue_as :maintenance

    queue_with_priority 300

    # @return [void]
    def perform
      AllowlistedJwt.expired.in_batches.delete_all
    end
  end
end
