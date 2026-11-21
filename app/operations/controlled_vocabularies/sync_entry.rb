# frozen_string_literal: true

module ControlledVocabularies
  # @see ControlledVocabularies::EntrySynchronizer
  class SyncEntry < Support::SimpleServiceOperation
    service_klass ControlledVocabularies::EntrySynchronizer
  end
end
