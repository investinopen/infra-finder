# frozen_string_literal: true

module SolutionImports
  module Persistence
    # Persist {SolutionIntake} records from an import source.
    #
    # @api private
    # @see SolutionImports::Persistence::IntakesPersister
    class PersistIntakes < Support::SimpleServiceOperation
      service_klass SolutionImports::Persistence::IntakesPersister
    end
  end
end
