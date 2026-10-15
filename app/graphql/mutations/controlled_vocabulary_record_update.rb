# frozen_string_literal: true

module Mutations
  # @see Mutations::Implementations::ControlledVocabularyRecordUpdate
  class ControlledVocabularyRecordUpdate < Mutations::MutateControlledVocabularyRecord
    description <<~TEXT
    Update a single `ControlledVocabularyRecord` record.
    TEXT

    argument :controlled_vocabulary_record_id, ID, loads: Types::ControlledVocabularyRecordType, required: true do
      description <<~TEXT
      The controlled vocabulary record to update.
      TEXT
    end

    performs_operation! "mutations.implementations.controlled_vocabulary_record_update"
  end
end
