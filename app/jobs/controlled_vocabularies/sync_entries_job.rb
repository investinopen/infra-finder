# frozen_string_literal: true

module ControlledVocabularies
  # @see ControlledVocabularies::SyncEntries
  # @see ControlledVocabularies::EntriesSynchronizer
  class SyncEntriesJob < ApplicationJob
    queue_as :maintenance

    # @return [void]
    def perform(*args)
      call_operation!("controlled_vocabularies.sync_entries")
    end
  end
end
