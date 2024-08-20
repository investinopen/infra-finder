# frozen_string_literal: true

module SolutionProperties
  module Types
    include Dry.Types

    extend Support::EnhancedTypes

    INPUT_TYPES = %w[
      boolean
      integer
      money
      multiselect
      select
      none
      text
      url
    ].freeze

    ValidYear = Integer.constrained(gteq: 1800) | String.constrained(format: /\A\d{4}\z/)

    YearToDate = Instance(::Date).constructor do |value|
      case value
      when ::Date then value
      when ValidYear then Params::Date["#{value}-01-01"]
      when Params::Date then value
      else
        # :nocov:
        raise Dry::Types::CoercionError, "invalid date: #{value.inspect}"
        # :nocov:
      end
    end

    AnyDate = Params::Date | YearToDate

    AssignMethod = Coercible::Symbol.enum(:write_attribute, :direct_write)

    CSVStrategy = Coercible::Symbol.default(:v2).enum(:v2, :eoi).fallback(:v2)

    Field = Coercible::Symbol

    Fields = Coercible::Array.of(Coercible::Symbol)

    Input = Coercible::String.default("none").enum(*INPUT_TYPES).fallback("none")

    Kind = Coercible::Symbol.enum(
      :attachment,
      :blurb,
      :boolean,
      :contact,
      :date,
      :email,
      :enum,
      :implementation,
      :implementation_enum,
      :implementation_property,
      :integer,
      :money,
      :multi_option,
      :other_option,
      :single_option,
      :standard,
      :string,
      :store_model_input,
      :store_model_list,
      :tag_list,
      :timestamp,
      :url
    )

    Owner = Coercible::String

    Phase2Status = Coercible::String.default("none").enum("add", "change_input", "change_label", "change_vocab", "drop", "keep", "none").fallback("none")

    SolutionKind = ApplicationRecord.dry_pg_enum(:solution_kind, symbolize: true)

    Visibility = Coercible::String.default("hidden").enum("visible", "hidden").fallback("hidden").constructor do |value|
      case value
      when "not visible" then "hidden"
      else
        value
      end
    end
  end
end
