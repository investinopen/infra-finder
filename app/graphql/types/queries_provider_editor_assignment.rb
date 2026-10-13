# frozen_string_literal: true

module Types
  # An interface for querying {ProviderEditorAssignment}.
  module QueriesProviderEditorAssignment
    include Types::BaseInterface

    description <<~TEXT
    An interface for querying `ProviderEditorAssignment` records.
    TEXT

    field :provider_editor_assignment, ::Types::ProviderEditorAssignmentType, null: true do
      description <<~TEXT
      Retrieve a single `ProviderEditorAssignment` by slug.
      TEXT

      argument :slug, Types::SlugType, required: true do
        description <<~TEXT
        The slug to look up.
        TEXT
      end
    end

    field :provider_editor_assignments, resolver: ::Resolvers::ProviderEditorAssignmentResolver

    # @param [String] slug
    # @return [ProviderEditorAssignment, nil]
    def provider_editor_assignment(slug:)
      load_record_with(ProviderEditorAssignment, slug)
    end
  end
end
