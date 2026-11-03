# frozen_string_literal: true

module Types
  # An interface for querying {Provider}.
  module QueriesProvider
    include Types::BaseInterface

    description <<~TEXT
    An interface for querying `Provider` records.
    TEXT

    field :provider, ::Types::ProviderType, null: true do
      description <<~TEXT
      Retrieve a single `Provider` by either its encoded slug or its human-readable URL slug.
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

    field :providers, resolver: ::Resolvers::ProviderResolver

    # @param [String, nil] slug
    # @param [String, nil] url_slug
    # @return [Provider, nil]
    def provider(slug: nil, url_slug: nil)
      return load_record_by_url_slug(Provider, url_slug) if url_slug.present?

      load_record_with(Provider, slug)
    end
  end
end
