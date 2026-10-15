# frozen_string_literal: true

module Mutations
  # @see Mutations::Implementations::ControlledVocabularyRecordsSetVisibility
  class ControlledVocabularyRecordsSetVisibility < Mutations::BaseMutation
    description <<~TEXT
    Show or hide several controlled vocabulary records at once.
    TEXT

    field :controlled_vocabulary_records, [Types::ControlledVocabularyRecordType, { null: false }], null: true do
      description <<~TEXT
      The updated records, if successful.
      TEXT
    end

    argument :controlled_vocabulary_record_ids, [ID, { null: false }], loads: Types::ControlledVocabularyRecordType, required: true do
      description <<~TEXT
      The records to update. They may come from different vocabularies.
      TEXT
    end

    argument :visibility, Types::VisibilityType, required: true do
      description "The visibility to give each record."
    end

    performs_operation! "mutations.implementations.controlled_vocabulary_records_set_visibility"
  end
end
