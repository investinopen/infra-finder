# frozen_string_literal: true

module ComparisonShares
  # Prune all stale {ComparisonShare} records.
  #
  # @see ComparisonShare.prunable
  class PruneJob < ApplicationJob
    include JobIteration::Iteration

    queue_as :maintenance

    queue_with_priority 300

    # @param [String] cursor
    # @return [Enumerator]
    def build_enumerator(cursor:)
      enumerator_builder.active_record_on_records(
        ComparisonShare.prunable,
        cursor:
      )
    end

    # @param [ComparisonShare] comparison_share
    def each_iteration(comparison_share)
      comparison_share.destroy!
    end
  end
end
