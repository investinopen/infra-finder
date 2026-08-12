# frozen_string_literal: true

module SolutionImports
  module Persistence
    # Persist a single {SolutionIntake} record from an import source.
    #
    # @api private
    # @see SolutionImports::Persistence::EachIntakePersister
    class PersistEachIntake < Support::SimpleServiceOperation
      service_klass SolutionImports::Persistence::EachIntakePersister
    end
  end
end
