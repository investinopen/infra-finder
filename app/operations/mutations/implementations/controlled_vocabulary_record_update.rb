# frozen_string_literal: true

module Mutations
  module Implementations
    # @see Mutations::ControlledVocabularyRecordUpdate
    class ControlledVocabularyRecordUpdate < VOGMutations::Implementation
      use_contract! :controlled_vocabulary_record_update
      use_contract! :mutate_controlled_vocabulary_record

      authorizes! :controlled_vocabulary_record, with: :update?

      # @param [ControlledVocabularyRecord] controlled_vocabulary_record
      # @param [{ Symbol => Object }] attrs
      # @return [void]
      def call(controlled_vocabulary_record:, **attrs)
        assign_attributes!(controlled_vocabulary_record, **attrs)

        persist_model! controlled_vocabulary_record, attach_to: :controlled_vocabulary_record
      end
    end
  end
end
