# frozen_string_literal: true

module Comparisons
  # Prune all stale {Comparison} records.
  #
  # @see Comparison.prunable
  class PruneJob < ApplicationJob
    include JobIteration::Iteration

    queue_as :maintenance

    queue_with_priority 300

    # @param [String] cursor
    # @return [Enumerator]
    def build_enumerator(cursor:)
      enumerator_builder.active_record_on_records(
        Comparison.prunable,
        cursor:
      )
    end

    # @param [Comparison] comparison
    def each_iteration(comparison)
      comparison.destroy!
    end
  end
end
