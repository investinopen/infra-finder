# frozen_string_literal: true

module Mutations
  module Contracts
    # @see Mutations::ControlledVocabularyRecordCreate
    # @see Mutations::Implementations::ControlledVocabularyRecordCreate
    class ControlledVocabularyRecordCreate < VOGMutations::Contract
      json do
        required(:controlled_vocabulary_record).value(:controlled_vocabulary_record)
        required(:name).filled(:string)
        required(:term).filled(:string)
      end
    end
  end
end
