# frozen_string_literal: true

module SolutionImports
  module Transient
    # A transient record to ensure an {Organization} exists.
    class OrganizationRow < Support::FlexibleStruct
      attribute :identifier, Types::Identifier
      attribute :name, Types::PresentString
      attribute? :url, Types::URL.optional

      # Attributes that are provided only when creating an {Organization}
      # for the first time. We do not overwrite changes to organizations
      # through the import process.
      #
      # @return [Hash]
      def attrs_to_create
        attributes.without(:identifier).compact_blank
      end
    end
  end
end
