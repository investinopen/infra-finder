# frozen_string_literal: true

module Mutations
  module Contracts
    # @see Mutations::MutateControlledVocabularyRecord
    class MutateControlledVocabularyRecord < VOGMutations::Contract
      json do
        optional(:controlled_vocabulary_record).value(:controlled_vocabulary_record)
        optional(:name).filled(:string)
        optional(:term).filled(:string)
        optional(:provides).maybe(:string)
        optional(:bespoke_filter_position).maybe(:integer)
        optional(:description).maybe(:string)
        optional(:visibility).filled(:string)
      end

      rule(:term) do
        record = values[:controlled_vocabulary_record]

        next unless key? && record

        key.failure(:must_not_contain_pipe) if ControlledVocabularyTermValidator::CONTAINS_SEPARATOR.match?(value)
        key.failure(:must_be_unique) if record.class.where.not(id: record.id).exists?(term: value)
      end

      # The model hides records with these provisions on save, so asking for VISIBLE would silently fail.
      rule(:visibility) do
        record = values[:controlled_vocabulary_record]

        next unless value == "visible" && record

        provides = values.key?(:provides) ? values[:provides] : record.provides

        key.failure(:cannot_be_visible) if provides.in?(record.class.auto_hidden_provisions)
      end
    end
  end
end
