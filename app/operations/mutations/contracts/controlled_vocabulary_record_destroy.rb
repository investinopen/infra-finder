# frozen_string_literal: true

module Mutations
  module Contracts
    # @see Mutations::ControlledVocabularyRecordDestroy
    # @see Mutations::Implementations::ControlledVocabularyRecordDestroy
    class ControlledVocabularyRecordDestroy < VOGMutations::Contract
      json do
        required(:controlled_vocabulary_record).value(:controlled_vocabulary_record)
      end
    end
  end
end
