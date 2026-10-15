# frozen_string_literal: true

module Mutations
  module Implementations
    # @see Mutations::ControlledVocabularyRecordReplace
    class ControlledVocabularyRecordReplace < VOGMutations::Implementation
      use_contract! :controlled_vocabulary_record_replace

      authorizes! :controlled_vocabulary_record, with: :replace?

      # @param [ControlledVocabularyRecord] controlled_vocabulary_record
      # @param [ControlledVocabularyRecord] replacement
      # @return [void]
      def call(controlled_vocabulary_record:, replacement:)
        check_result! call_operation("controlled_vocabularies.replace", controlled_vocabulary_record, replacement)

        attach! :replacement, replacement
      end
    end
  end
end
