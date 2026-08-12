# frozen_string_literal: true

module SolutionImports
  module Transient
    # A transient record to ensure a {Provider} exists.
    class ProviderRow < SolutionImports::Transient::AbstractRow
      attribute :name, Types::PresentString
      attribute? :url, Types::URL.optional

      # Attributes that are provided only when creating an {Provider}
      # for the first time. We do not overwrite changes to providers
      # through the import process.
      #
      # @return [Hash]
      def attrs_to_create = attributes.without(:identifier).compact_blank
    end
  end
end
