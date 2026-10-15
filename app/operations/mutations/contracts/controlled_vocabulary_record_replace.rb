# frozen_string_literal: true

module Mutations
  module Contracts
    # @see Mutations::ControlledVocabularyRecordReplace
    # @see Mutations::Implementations::ControlledVocabularyRecordReplace
    class ControlledVocabularyRecordReplace < VOGMutations::Contract
      json do
        required(:controlled_vocabulary_record).value(:controlled_vocabulary_record)
        required(:replacement).value(:controlled_vocabulary_record)
      end

      rule(:replacement) do
        record = values[:controlled_vocabulary_record]

        key.failure(:must_be_a_different_record) if value == record
        key.failure(:must_be_same_vocabulary) if value.class != record.class
      end
    end
  end
end
