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
      Retrieve a single `Solution` by either its encoded slug or its human-readable URL slug.
      TEXT

      argument :slug, Types::SlugType, required: false do
        description <<~TEXT
        The encoded slug to look up.
        TEXT
      end

      argument :url_slug, String, required: false do
        description <<~TEXT
        The human-readable slug to look up, as used in public URLs. Previous slugs also match.
        TEXT
      end

      validates required: { one_of: %i[slug url_slug] }
    end

    field :solutions, resolver: ::Resolvers::SolutionResolver

    # @param [String, nil] slug
    # @param [String, nil] url_slug
    # @return [Solution, nil]
    def solution(slug: nil, url_slug: nil)
      return load_record_by_url_slug(Solution, url_slug) if url_slug.present?

      load_record_with(Solution, slug)
    end
  end
end
