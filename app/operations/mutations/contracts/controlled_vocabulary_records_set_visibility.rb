# frozen_string_literal: true

module Mutations
  module Contracts
    # @see Mutations::ControlledVocabularyRecordsSetVisibility
    # @see Mutations::Implementations::ControlledVocabularyRecordsSetVisibility
    class ControlledVocabularyRecordsSetVisibility < VOGMutations::Contract
      json do
        required(:controlled_vocabulary_records).filled(:controlled_vocabulary_records)
        required(:visibility).filled(:string)
      end

      # The model hides records with auto-hidden provisions on save, so asking for VISIBLE would silently fail.
      rule(:visibility) do
        key.failure(:cannot_be_visible) if value == "visible" && values[:controlled_vocabulary_records].any?(&:has_auto_hidden_provision?)
      end
    end
  end
end
