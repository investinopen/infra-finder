# frozen_string_literal: true

module Types
  # @see SolutionProperties::GraphQLOptions
  class SolutionPropertyOptionType < Types::BaseObject
    description <<~TEXT
    A choice for a solution property that is not backed by controlled vocabulary records.
    TEXT

    field :label, String, null: false do
      description "A human-readable label."
    end

    field :value, String, null: false do
      description "The value the API sends and accepts, e.g. an enum name or a country code."
    end
  end
end
