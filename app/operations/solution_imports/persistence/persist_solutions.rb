# frozen_string_literal: true

module SolutionImports
  module Persistence
    # Persist transient {Solution} records from an import source.
    #
    # @api private
    # @see SolutionImports::Persistence::SolutionPersister
    class PersistSolutions < Support::SimpleServiceOperation
      service_klass SolutionImports::Persistence::SolutionPersister
    end
  end
end
