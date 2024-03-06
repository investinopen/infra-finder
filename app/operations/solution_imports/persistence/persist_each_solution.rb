# frozen_string_literal: true

module SolutionImports
  module Persistence
    # Persist a single transient {Solution} record from an import source.
    #
    # @api private
    # @see SolutionImports::Persistence::EachSolutionPersister
    class PersistEachSolution < Support::SimpleServiceOperation
      service_klass SolutionImports::Persistence::EachSolutionPersister
    end
  end
end
