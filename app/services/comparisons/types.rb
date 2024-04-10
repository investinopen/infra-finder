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

    SessionID = Utility::Types::SessionID

    SolutionIDs = Types::Array.of(Types::String).fallback { [] }
  end
end
