# frozen_string_literal: true

module Solutions
  module Types
    include Dry.Types

    extend Support::EnhancedTypes

    Actual = ModelInstance("Solution")

    Draft = ModelInstance("SolutionDraft")

    AnySolution = Actual | Draft

    FieldKind = Coercible::Symbol.enum(
      :attachment,
      :blurb,
      :enum,
      :implementation,
      :multi_option,
      :single_option,
      :standard,
      :store_model_list,
      :tag_list
    )

    Kind = Coercible::Symbol.enum(:actual, :draft)

    Implementation = ApplicationRecord.dry_pg_enum(:solution_implementation)

    ImplementationLinkMode = Coercible::Symbol.enum(:many, :single, :none)

    Option = Instance(::SolutionOption)

    OptionMode = Coercible::Symbol.enum(:single, :multiple)

    User = ModelInstance("User")
  end
end
