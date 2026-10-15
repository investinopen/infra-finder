# frozen_string_literal: true

module Mutations
  # @see Mutations::Implementations::ControlledVocabularyRecordCreate
  class ControlledVocabularyRecordCreate < Mutations::MutateControlledVocabularyRecord
    description <<~TEXT
    Create a record in one of the controlled vocabularies.
    TEXT

    argument :kind, Types::ControlledVocabularyKindType, required: true do
      description "The vocabulary to add the record to."
    end

    performs_operation! "mutations.implementations.controlled_vocabulary_record_create"
  end
end
