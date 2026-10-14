# frozen_string_literal: true

module Types
  # An interface for querying {SolutionImport}.
  module QueriesSolutionImport
    include Types::BaseInterface

    description <<~TEXT
    An interface for querying `SolutionImport` records.
    TEXT

    field :solution_imports, resolver: ::Resolvers::SolutionImportResolver
  end
end
