# frozen_string_literal: true

module SolutionImports
  module Persistence
    # Persist {Provider} records from an import source.
    #
    # @api private
    # @see SolutionImports::Persistence::ProviderPersister
    class PersistProviders < Support::SimpleServiceOperation
      service_klass SolutionImports::Persistence::ProviderPersister
    end
  end
end
