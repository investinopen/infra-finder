# frozen_string_literal: true

module SolutionImports
  module Transient
    # A transient record to ensure an {Solution} exists.
    class SolutionRow < Support::FlexibleStruct
      include Dry::Core::Memoizable

      attribute :identifier, Types::Identifier
      attribute :provider_identifier, Types::Identifier
      attribute :name, Types::PresentString

      attribute :assignments, Types::Assignments

      # The bare-minimum attributes to merely _create_ a {Solution} or a {SolutionDraft}.
      #
      # The import process makes use of the draft process, to provide
      # an audit trail and cut down on the ways that solutions get modified.
      #
      # @return [Hash]
      def attrs_to_create
        { name:, }
      end

      # @return [<SolutionProperties::Assignment>]
      memoize def attachment_assignments
        assignments.select(&:attachment?)
      end

      # @return [<SolutionProperties::Assignment>]
      memoize def standard_assignments
        assignments.select(&:standard?)
      end
    end
  end
end
