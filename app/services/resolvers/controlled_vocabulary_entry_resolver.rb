# frozen_string_literal: true

module Resolvers
  # A resolver for the cached {ControlledVocabularyEntry} records.
  #
  # @see Types::QueriesControlledVocabulary#controlled_vocabularies
  class ControlledVocabularyEntryResolver < AbstractResolver
    type [::Types::ControlledVocabularyType, { null: false }], null: false

    resolves_model! ::ControlledVocabularyEntry, from_object: false

    orders_with! ::Types::ControlledVocabularyOrderType, default: "name_ascending"

    order_pair! :records_count

    # @return [ActiveRecord::Relation<ControlledVocabularyEntry>]
    def resolve_default_scope = model_klass.as_model
  end
end
