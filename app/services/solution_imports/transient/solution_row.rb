# frozen_string_literal: true

module SolutionImports
  module Transient
    # A transient record to ensure an {Solution} exists.
    class SolutionRow < SolutionImports::Transient::SolutionishRow
      attribute :provider_identifier, Types::Identifier

      # The bare-minimum attributes to merely _create_ a {Solution} or a {SolutionDraft}.
      #
      # The import process makes use of the draft process, to provide
      # an audit trail and cut down on the ways that solutions get modified.
      #
      # @return [Hash]
      def attrs_to_create = { name:, }
    end
  end
end
