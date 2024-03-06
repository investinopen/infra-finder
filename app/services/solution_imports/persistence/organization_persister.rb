# frozen_string_literal: true

module SolutionImports
  module Persistence
    # Persist transient {Organization} records from an import source.
    #
    # @see SolutionImports::Persistence::ExtractOrganizations
    class OrganizationPersister < SolutionImports::Persistence::BasePersister
      def perform
        context.transient_organizations.each do |row|
          organization = Organization.where(identifier: row.identifier).first_or_initialize do |org|
            org.assign_attributes row.attrs_to_create
          end

          yield monadic_save organization

          yield track_import_of! organization
        end

        super
      end
    end
  end
end
