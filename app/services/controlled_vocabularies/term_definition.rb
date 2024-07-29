# frozen_string_literal: true

module ControlledVocabularies
  class TermDefinition < Support::FlexibleStruct
    include Support::Typing

    attribute :term, Types::Term

    attribute? :provides, Types::String.optional

    attribute? :slug, Types::String.optional

    attribute? :tags, Types::Array.of(Types::Term).default([].freeze)

    attribute? :visibility, Types::Visibility

    alias enforced_slug slug

    def to_assign
      { slug:, enforced_slug:, provides:, visibility:, }
    end
  end
end
