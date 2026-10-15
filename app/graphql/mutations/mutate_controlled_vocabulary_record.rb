# frozen_string_literal: true

module Mutations
  # @abstract
  # @see Mutations::ControlledVocabularyRecordCreate
  # @see Mutations::ControlledVocabularyRecordUpdate
  class MutateControlledVocabularyRecord < Mutations::BaseMutation
    description <<~TEXT
    A base mutation that is used to share fields between `controlledVocabularyRecordCreate` and `controlledVocabularyRecordUpdate`.
    TEXT

    field :controlled_vocabulary_record, Types::ControlledVocabularyRecordType, null: true do
      description <<~TEXT
      The newly-modified controlled vocabulary record, if successful.
      TEXT
    end

    argument :name, String, required: false do
      description "The record's display name."
    end

    argument :term, String, required: false do
      description "The record's unique term within its vocabulary, used in imports and exports."
    end

    argument :provides, Types::ControlledVocabularyProvisionType, required: false do
      description "What the record provides, for the vocabularies that track it."
    end

    argument :bespoke_filter_position, Integer, required: false do
      description "The record's position in the public site's filters."
    end

    argument :description, String, required: false do
      description "An internal description of the record."
    end

    argument :visibility, Types::VisibilityType, required: false do
      description "Whether the record is offered in forms and filters."
    end
  end
end
