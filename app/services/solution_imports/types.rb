# frozen_string_literal: true

module SolutionImports
  # Types for the {Solution} Import subsystem.
  module Types
    include Dry.Types

    extend Support::EnhancedTypes

    Blurb = String.optional

    # The current_staffing value in the legacy database is a float. This makes no sense,
    # and it should be treated as an integer.
    CorrectedFloat = Types::Integer.optional.constructor do |value|
      # :nocov:
      case value
      in nil then nil
      in Types::Coercible::Float => flt
        Types::Coercible::Float[flt].ceil
      in Types::Coercible::Integer => int
        Types::Coercible::Integer[int]
      else
        raise Dry::Types::CoercionError, "invalid staffing value: #{value.inspect}"
      end
      # :nocov:
    end

    FinancialNumbersApplicability = ApplicationRecord.dry_pg_enum(:financial_numbers_applicability).fallback("unknown")

    FinancialNumbersPublishability = ApplicationRecord.dry_pg_enum(:financial_numbers_publishability).fallback("unknown")

    FinancialInformationScope = ApplicationRecord.dry_pg_enum(:financial_information_scope).fallback("unknown")

    Identifier = Coercible::String.constrained(filled: true)

    Implementation = ApplicationRecord.dry_pg_enum(:solution_implementation)

    ImplementationData = Hash.default { {} }

    ImplementationStatus = ApplicationRecord.dry_pg_enum(:implementation_status).fallback("unknown")

    MaintenanceStatus = ApplicationRecord.dry_pg_enum(:maintenance_status).fallback("unknown")

    PresentString = String.constrained(filled: true)

    SolutionImport = ModelInstance("SolutionImport")

    StoreModelData = Hash.default { {} }

    StoreModelList = Coercible::Array.of(StoreModelData).default { [] }

    Strategy = ApplicationRecord.dry_pg_enum(:solution_import_strategy)

    TagList = Coercible::String.default { "" }

    URL = String.constrained(http_uri: true)

    User = ModelInstance("User")
  end
end
