# frozen_string_literal: true

module Implementations
  module Types
    include Dry.Types

    extend Support::EnhancedTypes

    Data = Hash.default { {} }

    EnumType = Coercible::String.default("implementation_status").enum("implementation_status", "pricing_implementation_status")

    LinkMode = Coercible::Symbol.enum(:many, :single, :none)

    Name = ApplicationRecord.dry_pg_enum(:implementation_name)

    Property = Coercible::String.enum(
      "enum",
      "link",
      "links",
      "statement",
      "flag"
    )

    PricingStatus = ApplicationRecord.dry_pg_enum(:pricing_implementation_status)

    Status = ApplicationRecord.dry_pg_enum(:implementation_status)
  end
end
