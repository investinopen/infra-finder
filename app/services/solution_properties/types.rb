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

    AssignMethod = Coercible::Symbol.enum(:write_attribute, :direct_write)

    Field = Coercible::Symbol

    Fields = Coercible::Array.of(Coercible::Symbol)

    Input = Coercible::String.default("none").enum(*INPUT_TYPES).fallback("none")

    Kind = Coercible::Symbol.enum(
      :attachment,
      :blurb,
      :boolean,
      :contact,
      :date,
      :enum,
      :implementation,
      :implementation_enum,
      :implementation_property,
      :integer,
      :money,
      :multi_option,
      :single_option,
      :standard,
      :string,
      :store_model_list,
      :tag_list,
      :timestamp,
      :url
    )

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
