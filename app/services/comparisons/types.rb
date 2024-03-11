# frozen_string_literal: true

module Comparisons
  # Types related to a {Comparison}
  module Types
    include Dry.Types

    extend Support::EnhancedTypes

    Comparison = ModelInstance("Comparison")

    Item = ModelInstance("ComparisonItem")

    LoadStrategy = Symbol.enum(:fetch, :find_existing, :skip)

    SessionID = Utility::Types::SessionID
  end
end
