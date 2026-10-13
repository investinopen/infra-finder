# frozen_string_literal: true

module Types
  # @see Resolvers::OrderedAsProvider
  class ProviderOrderType < Types::BaseEnum
    description <<~TEXT
    Sort a collection of `Provider` records by specific properties and directions.
    TEXT

    value "DEFAULT" do
      description "Sort providers by their default order."
    end

    value "RECENT" do
      description "Sort providers by newest created date."
    end

    value "OLDEST" do
      description "Sort providers by oldest created date."
    end

    value "NAME_ASCENDING" do
      description "Sort providers by name in ascending (A-Z) order."
    end

    value "NAME_DESCENDING" do
      description "Sort providers by name in descending (Z-A) order."
    end
  end
end
