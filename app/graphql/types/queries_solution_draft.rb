# frozen_string_literal: true

module Types
  # An interface for querying {SolutionDraft}.
  module QueriesSolutionDraft
    include Types::BaseInterface

    description <<~TEXT
    An interface for querying `SolutionDraft` records.
    TEXT

    field :solution_drafts, resolver: ::Resolvers::SolutionDraftResolver
  end
end
