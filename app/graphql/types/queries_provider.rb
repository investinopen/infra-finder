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
      Retrieve a single `Provider` by slug.
      TEXT

      argument :slug, Types::SlugType, required: true do
        description <<~TEXT
        The slug to look up.
        TEXT
      end
    end

    field :providers, resolver: ::Resolvers::ProviderResolver

    # @param [String] slug
    # @return [Provider, nil]
    def provider(slug:)
      load_record_with(Provider, slug)
    end
  end
end
