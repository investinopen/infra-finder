# frozen_string_literal: true

module Comparisons
  # Prune all stale {Comparison} records.
  #
  # @see Comparison.prunable
  class PruneJob < ApplicationJob
    queue_as :maintenance

    # @return [void]
    def perform
      Comparison.prunable.destroy_all
    end
  end
end
