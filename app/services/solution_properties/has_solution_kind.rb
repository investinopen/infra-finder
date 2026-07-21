# frozen_string_literal: true

module SolutionProperties
  module HasSolutionKind
    extend ActiveSupport::Concern

    included do
      extend Dry::Core::ClassAttributes

      defines :solution_kind, type: Solutions::Types::Kind

      case name
      in "Solution"
        solution_kind :actual
      in "SolutionDraft"
        solution_kind :draft
      in "SolutionIntake"
        solution_kind :intake
      end
    end

    # @!attribute [r] solution_kind
    # @return [Solutions::Types::Kind]
    def solution_kind = self.class.solution_kind

    module ClassMethods
      def actual? = name == "Solution"

      def draft? = name == "SolutionDraft"

      def intake? = name == "SolutionIntake"
    end
  end
end
