# frozen_string_literal: true

module SolutionDrafts
  class ChangedField < Support::FlexibleStruct
    extend Dry::Core::Cache

    attribute :field, Types::Coercible::Symbol

    attribute :field_kind, SolutionProperties::Types::Kind

    attribute? :source_value, Types::Any.optional
    attribute? :target_value, Types::Any.optional

    delegate :diffable?, to: :property_kind

    # @!attribute [r] property_kind
    # @return [SolutionPropertyKind]
    def property_kind
      fetch_or_store field_kind do
        SolutionPropertyKind.find field_kind
      end
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
        context.image_tag value.url, class: "solution-property--image-diff"
      in :blurb
        context.content_tag(:div, class: "solution-property--diff-wrapper") do
          value.html_safe
        end
      in :boolean
        value
      in :multi_option
        value
      in :single_option
        value
      else
        context.content_tag(:div, class: "solution-property--diff-wrapper") do
          value
        end
      end
    end
  end
end
