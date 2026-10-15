# frozen_string_literal: true

module Mutations
  module Implementations
    # @see Mutations::ControlledVocabularyRecordCreate
    class ControlledVocabularyRecordCreate < VOGMutations::Implementation
      use_contract! :controlled_vocabulary_record_create
      use_contract! :mutate_controlled_vocabulary_record

      authorizes! :controlled_vocabulary_record, with: :create?

      # @param [ControlledVocabularyRecord] controlled_vocabulary_record
      # @param [String] kind
      # @param [{ Symbol => Object }] attrs
      # @return [void]
      def call(controlled_vocabulary_record:, kind:, **attrs)
        assign_attributes!(controlled_vocabulary_record, **attrs)

        persist_model! controlled_vocabulary_record, attach_to: :controlled_vocabulary_record
      end

      # Build the record from `kind` before authorization, which checks `create?` against it.
      #
      # @return [void]
      before_prepare def initialize_controlled_vocabulary_record!
        args[:controlled_vocabulary_record] = args.fetch(:kind).constantize.new
      end
    end
  end
end
