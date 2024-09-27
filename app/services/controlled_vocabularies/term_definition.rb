# frozen_string_literal: true

module ControlledVocabularies
  class TermDefinition < Support::FlexibleStruct
    include Support::Typing

    attribute :term, Types::Term

    attribute? :bespoke_filter_position, Types::Integer.optional

    attribute? :provides, Types::String.optional

    attribute? :slug, Types::String.optional

    attribute? :tags, Types::Array.of(Types::Term).default([].freeze)

    attribute? :visibility, Types::Visibility

    alias enforced_slug slug
    alias name term

    def to_assign
      { slug:, enforced_slug:, provides:, visibility:, bespoke_filter_position:, }
    end

    def for_values_list
      [name, term, slug, enforced_slug, provides, visibility, bespoke_filter_position]
    end
  end
end
