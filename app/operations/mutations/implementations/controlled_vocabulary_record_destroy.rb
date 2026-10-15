# frozen_string_literal: true

module Mutations
  module Implementations
    # @see Mutations::ControlledVocabularyRecordDestroy
    class ControlledVocabularyRecordDestroy < VOGMutations::Implementation
      use_contract! :controlled_vocabulary_record_destroy

      authorizes! :controlled_vocabulary_record, with: :destroy?

      # @param [ControlledVocabularyRecord] controlled_vocabulary_record
      # @return [void]
      def call(controlled_vocabulary_record:)
        destroy_model! controlled_vocabulary_record, auth: true
      end
    end
  end
end
