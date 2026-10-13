# frozen_string_literal: true

module Searching
  # A struct representing the parameters for a full-text search query.
  #
  # @see ::Types::SearchStrategyType
  # @see ::Types::SearchQueryInputType
  class Query < Support::FlexibleStruct
    include Dry::Matcher.for(:apply, with: Searching::Matcher)
    include Support::Typing

    with_gql_type! ::Types::SearchQueryInputType

    attribute :needle, Types::Needle

    attribute? :strategy, Types::Strategy

    def apply = self

    def empty? = needle.blank?

    def exact? = strategy == "exact"

    def fuzzy? = strategy == "fuzzy"

    def prefix? = strategy == "prefix"

    def ranked_by_relevance? = present? && (fuzzy? || prefix?)

    class << self
      # @param [Searching::Query, String, Hash] input the input to convert to a `Searching::Query` instance
      # @param ["fuzzy", "prefix"] strategy the default search strategy to use when the input is a string or hash without a specified strategy
      # @return [Searching::Query] a `Searching::Query` instance representing the provided input
      def from(input, strategy: "fuzzy")
        case input
        when self then input
        when String then new(needle: input, strategy:)
        when Hash then new(strategy:, **input)
        else
          raise ArgumentError, "Cannot convert #{input.inspect} to #{self}"
        end
      end
    end
  end
end
