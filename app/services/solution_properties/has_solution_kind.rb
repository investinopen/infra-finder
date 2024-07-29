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
      end
    end

    # @!attribute [r] solution_kind
    # @return [Solutions::Types::Kind]
    def solution_kind
      self.class.solution_kind
    end

    module ClassMethods
      def draft?
        name == "SolutionDraft"
      end
    end
  end
end
