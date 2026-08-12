# frozen_string_literal: true

module SolutionImports
  module Transient
    # A transient record to ensure an {SolutionIntake} exists.
    class IntakeRow < SolutionImports::Transient::SolutionishRow
      attribute? :provider_identifier, Types::Identifier.optional

      # The bare-minimum attributes to merely _create_ a {SolutionIntake}.
      #
      # @return [Hash]
      def attrs_to_create = { name:, }
    end
  end
end
