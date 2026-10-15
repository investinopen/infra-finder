# frozen_string_literal: true

module Mutations
  module Implementations
    # @see Mutations::ControlledVocabularyRecordsSetVisibility
    class ControlledVocabularyRecordsSetVisibility < VOGMutations::Implementation
      use_contract! :controlled_vocabulary_records_set_visibility

      authorizes! :controlled_vocabulary_records, with: :update?

      # @param [<ControlledVocabularyRecord>] controlled_vocabulary_records
      # @param [String] visibility
      # @return [void]
      def call(controlled_vocabulary_records:, visibility:)
        # `invalid_model!` raises, which rolls back the records already updated.
        ApplicationRecord.transaction do
          controlled_vocabulary_records.each do |record|
            invalid_model! record unless record.update(visibility:)
          end
        end

        attach! :controlled_vocabulary_records, controlled_vocabulary_records
      end
    end
  end
end
