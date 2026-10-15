# frozen_string_literal: true

module Mutations
  # @see Mutations::Implementations::ControlledVocabularyRecordDestroy
  class ControlledVocabularyRecordDestroy < Mutations::BaseMutation
    description <<~TEXT
    Destroy a single `ControlledVocabularyRecord` record.
    TEXT

    argument :controlled_vocabulary_record_id, ID, loads: Types::ControlledVocabularyRecordType, required: true do
      description <<~TEXT
      The controlled vocabulary record to destroy.
      TEXT
    end

    performs_operation! "mutations.implementations.controlled_vocabulary_record_destroy", destroy: true
  end
end
