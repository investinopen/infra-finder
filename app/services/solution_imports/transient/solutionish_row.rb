# frozen_string_literal: true

module SolutionImports
  module Transient
    # A transient record to ensure a {Solution} exists.
    #
    # @abstract
    class SolutionishRow < SolutionImports::Transient::AbstractRow
      include Dry::Core::Memoizable

      attribute :name, Types::PresentString

      attribute :assignments, Types::Assignments

      # @note Calculated from {#assignments}.
      # @return [<SolutionProperties::Assignment>]
      attr_reader :attachment_assignments

      # @note Calculated from {#assignments}.
      # @return [<SolutionProperties::Assignment>]
      attr_reader :standard_assignments

      def initialize(...)
        super

        @attachment_assignments = assignments.select(&:attachment?)

        @standard_assignments = assignments.select(&:standard?)
      end

      # The bare-minimum attributes to merely _create_ a {Solution} or a {SolutionDraft}.
      #
      # The import process makes use of the draft process, to provide
      # an audit trail and cut down on the ways that solutions get modified.
      #
      # @return [Hash]
      def attrs_to_create
        { name:, }
      end
    end
  end
end
