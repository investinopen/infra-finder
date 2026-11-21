# frozen_string_literal: true

module Types
  # An interface for querying controlled vocabularies.
  #
  # Individual records are looked up with `node(id:)`.
  module QueriesControlledVocabulary
    include Types::BaseInterface

    description <<~TEXT
    An interface for querying controlled vocabularies.
    TEXT

    field :controlled_vocabularies, resolver: ::Resolvers::ControlledVocabularyEntryResolver do
      description "Every controlled vocabulary."
    end

    field :controlled_vocabulary, ::Types::ControlledVocabularyType, null: false do
      description "A single controlled vocabulary."

      argument :kind, ::Types::ControlledVocabularyKindType, required: true do
        description "The vocabulary to retrieve."
      end
    end

    # @param [String] kind
    # @return [ControlledVocabularyEntry]
    def controlled_vocabulary(kind:) = ControlledVocabularyEntry.as_model.find_by!(kind:)
  end
end
