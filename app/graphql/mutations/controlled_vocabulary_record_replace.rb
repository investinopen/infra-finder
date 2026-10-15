# frozen_string_literal: true

module Mutations
  # @see Mutations::Implementations::ControlledVocabularyRecordReplace
  class ControlledVocabularyRecordReplace < Mutations::BaseMutation
    description <<~TEXT
    Replace a controlled vocabulary record with another from the same vocabulary: every solution
    and draft that used it moves to the replacement, and the original is deleted.
    TEXT

    field :replacement, Types::ControlledVocabularyRecordType, null: true do
      description <<~TEXT
      The replacement record, if successful.
      TEXT
    end

    argument :controlled_vocabulary_record_id, ID, loads: Types::ControlledVocabularyRecordType, required: true do
      description <<~TEXT
      The record to replace and delete.
      TEXT
    end

    argument :replacement_id, ID, loads: Types::ControlledVocabularyRecordType, required: true do
      description <<~TEXT
      The record to use instead. It must belong to the same vocabulary.
      TEXT
    end

    performs_operation! "mutations.implementations.controlled_vocabulary_record_replace"
  end
end
