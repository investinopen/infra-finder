# frozen_string_literal: true

module SolutionImports
  module Persistence
    # Persist transient {Organization} records from an import source.
    #
    # @api private
    # @see SolutionImports::Persistence::OrganizationPersister
    class PersistOrganizations < Support::SimpleServiceOperation
      service_klass SolutionImports::Persistence::OrganizationPersister
    end
  end
end
