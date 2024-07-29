# frozen_string_literal: true

module ControlledVocabularies
  class UpsertRecords < Support::SimpleServiceOperation
    service_klass ControlledVocabularies::RecordUpserter
  end
end
