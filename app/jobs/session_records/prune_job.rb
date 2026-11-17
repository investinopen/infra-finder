# frozen_string_literal: true

module SessionRecords
  # Prune database sessions that have not been used within the session TTL.
  #
  # @see SessionRecord
  # @see SessionConfig#ttl
  class PruneJob < ApplicationJob
    queue_as :maintenance

    queue_with_priority 300

    # @return [void]
    def perform
      ::SessionRecord.expired.prune!

      ::Sessions.sweep!
    end
  end
end
