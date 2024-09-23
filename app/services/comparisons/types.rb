# frozen_string_literal: true

module Comparisons
  # Types related to a {Comparison}
  module Types
    include Dry.Types

    extend Support::EnhancedTypes

    Comparison = ModelInstance("Comparison")

    ComparisonShare = ModelInstance("ComparisonShare")

    Item = ModelInstance("ComparisonItem")

    ShareItem = ModelInstance("ComparisonShareItem")

    LoadStrategy = Symbol.enum(:fetch, :find_existing, :skip)

    SearchFilters = Types::Hash.fallback { {}.freeze }

    SearchFilterGrouping = Coercible::Symbol.enum(
      :business_form,
      :community_engagement,
      :flag,
      :global,
      :policy,
      :solution_category,
      :standard,
      :technical_attribute
    )

    SearchFilterGroupings = Hash.map(Symbol, SearchFilterGrouping)

    SearchFilterMapping = Hash.map(SearchFilterGrouping, Array.of(Symbol))

    GroupedSearchFilters = Hash.map(SearchFilterGrouping, Hash)

    SessionID = Utility::Types::SessionID

    SolutionIDs = Types::Array.of(Types::String).fallback { [] }

    SolutionRelation = Support::Types::Relation.of(::Solution)
  end
end
