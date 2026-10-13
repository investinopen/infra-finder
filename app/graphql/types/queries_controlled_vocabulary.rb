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

    field :controlled_vocabularies, [::Types::ControlledVocabularyType, { null: false }], null: false do
      description "Every controlled vocabulary."
    end

    field :controlled_vocabulary, ::Types::ControlledVocabularyType, null: false do
      description "A single controlled vocabulary."

      argument :kind, ::Types::ControlledVocabularyKindType, required: true do
        description "The vocabulary to retrieve."
      end
    end

    # @return [<ControlledVocabulary>]
    def controlled_vocabularies
      ControlledVocabulary.with_model_name.sort_by(&:model_name)
    end

    # @param [String] kind
    # @return [ControlledVocabulary]
    def controlled_vocabulary(kind:)
      ControlledVocabulary.with_model_name.find_by!(model_name: kind)
    end
  end
end
