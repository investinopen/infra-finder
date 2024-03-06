# frozen_string_literal: true

module SolutionImports
  # Types for the {Solution} Import subsystem.
  module Types
    include Dry.Types

    extend Support::EnhancedTypes

    Blurb = String.optional

    FinancialNumbersApplicability = ApplicationRecord.dry_pg_enum(:financial_numbers_applicability).fallback("unknown")

    FinancialNumbersPublishability = ApplicationRecord.dry_pg_enum(:financial_numbers_publishability).fallback("unknown")

    FinancialInformationScope = ApplicationRecord.dry_pg_enum(:financial_information_scope).fallback("unknown")

    Identifier = Coercible::String.constrained(filled: true)

    Implementation = ApplicationRecord.dry_pg_enum(:solution_implementation)

    ImplementationData = Hash.default { {} }

    ImplementationStatus = ApplicationRecord.dry_pg_enum(:implementation_status).fallback("unknown")

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
