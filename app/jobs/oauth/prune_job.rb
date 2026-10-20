# frozen_string_literal: true

module OAuth
  # Prune authorization codes and tokens that can no longer be used. The SPA
  # starts a token session on every page load, so these accumulate quickly.
  class PruneJob < ApplicationJob
    queue_as :maintenance

    queue_with_priority 300

    # @return [void]
    def perform
      OAuth::AccessGrant.where(created_at: ...1.day.ago).in_batches.delete_all

      OAuth::AccessToken.where(revoked_at: ...Time.current).in_batches.delete_all

      OAuth::AccessToken.session_ended.in_batches.delete_all
    end
  end
end
