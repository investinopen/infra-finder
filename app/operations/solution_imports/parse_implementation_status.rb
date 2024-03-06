# frozen_string_literal: true

module SolutionImports
  # @note This is a non-monadic operation as it will always resolve to a valid value.
  class ParseImplementationStatus
    include Dry::Monads[:result]

    # @param [Integer, #to_s] input
    # @return [SolutionImports::Types::ImplementationStatus]
    def call(input)
      case input
      in 1
        "not_planning"
      in 2
        "considering"
      in 3
        "in_progress"
      in 4
        "available"
      in 5
        "not_applicable"
      in 6
        "unknown"
      in /Considering/i
        "considering"
      in %r{Implemented/available}i
        "available"
      in /In progress/i
        "in_progress"
      in /Not applicable/i
        "not_applicable"
      in /Not planning/i
        "not_planning"
      in SolutionImports::Types::ImplementationStatus => status
        status
      else
        # :nocov:
        "unknown"
        # :nocov:
      end.then { SolutionImports::Types::ImplementationStatus[_1] }
    end
  end
end
