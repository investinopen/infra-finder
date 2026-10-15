# frozen_string_literal: true

module Mutations
  module Contracts
    # @see Mutations::ControlledVocabularyRecordUpdate
    # @see Mutations::Implementations::ControlledVocabularyRecordUpdate
    class ControlledVocabularyRecordUpdate < VOGMutations::Contract
      json do
        required(:controlled_vocabulary_record).value(:controlled_vocabulary_record)
      end
    end
  end
end
