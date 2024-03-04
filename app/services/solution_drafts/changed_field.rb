# frozen_string_literal: true

module SolutionDrafts
  class ChangedField < Support::FlexibleStruct
    include Dry::Core::Memoizable

    attribute :field, Types::Coercible::Symbol

    attribute :field_kind, Types::FieldKind

    attribute? :source_value, Types::Any.optional
    attribute? :target_value, Types::Any.optional

    DIFFABLE_FIELD_KINDS = %i[attachment enum multi_option single_option standard tag_list].freeze

    def diffable?
      field_kind.in?(DIFFABLE_FIELD_KINDS)
    end

    def try_diffing_source(context)
      try_diffing context, source_value
    end

    def try_diffing_target(context)
      try_diffing(context, target_value)
    end

    private

    def try_diffing(context, value)
      unless diffable?
        context.text_node "Not diffable here, check the actual value."

        return
      end

      return value if value.blank?

      case field_kind
      in :attachment
        context.image_tag value.url
      else
        return value
      end
    end
  end
end
