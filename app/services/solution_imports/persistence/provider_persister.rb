# frozen_string_literal: true

module SolutionImports
  module Persistence
    # Persist transient {Provider} records from an import source.
    #
    # @see SolutionImports::Persistence::PersistProviders
    class ProviderPersister < SolutionImports::Persistence::BasePersister
      def perform
        context.transient_providers.each do |row|
          provider = Provider.where(identifier: row.identifier).first_or_initialize do |prov|
            prov.assign_attributes row.attrs_to_create
          end

          yield monadic_save provider

          yield track_import_of! provider
        end

        super
      end
    end
  end
end
