# frozen_string_literal: true

module ControlledVocabularies
  # @see ControlledVocabularies::EntriesSynchronizer
  class SyncEntries < Support::SimpleServiceOperation
    service_klass ControlledVocabularies::EntriesSynchronizer
  end
end
