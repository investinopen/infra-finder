# frozen_string_literal: true

module Types
  # An interface for querying {Solution}.
  module QueriesSolution
    include Types::BaseInterface

    description <<~TEXT
    An interface for querying `Solution` records.
    TEXT

    field :solution, ::Types::SolutionType, null: true do
      description <<~TEXT
      Retrieve a single `Solution` by slug.
      TEXT

      argument :slug, Types::SlugType, required: true do
        description <<~TEXT
        The slug to look up.
        TEXT
      end
    end

    field :solutions, resolver: ::Resolvers::SolutionResolver

    # @param [String] slug
    # @return [Solution, nil]
    def solution(slug:)
      load_record_with(Solution, slug)
    end
  end
end
