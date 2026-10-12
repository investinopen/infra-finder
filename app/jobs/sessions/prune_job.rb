# frozen_string_literal: true

module Sessions
  # Prune database sessions that have not been used within the session TTL.
  #
  # @see SessionConfig#ttl
  class PruneJob < ApplicationJob
    queue_as :maintenance

    queue_with_priority 300

    # @return [void]
    def perform
      ActiveRecord::SessionStore::Session.where(updated_at: ...SessionConfig.ttl.days.ago).in_batches.delete_all
    end
  end
end
