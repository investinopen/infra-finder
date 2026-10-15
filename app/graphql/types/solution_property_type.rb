# frozen_string_literal: true

module Types
  # Describes one solution property, so clients can render forms without
  # hardcoding them.
  #
  # @see SolutionProperty
  class SolutionPropertyType < Types::BaseObject
    description <<~TEXT
    Describes one solution property, for rendering forms and displays.
    TEXT

    field :key, String, null: false, method: :name do
      description "The property's internal name."
    end

    field :field_name, String, null: true, method: :graphql_field_name do
      description <<~TEXT
      The field that holds the value: on `SolutionInterface`, or on `Solution` for properties only
      solutions have (see `availableOn`). Null for properties not exposed through the API.
      TEXT
    end

    field :label, String, null: false, method: :input_label do
      description "A human-readable label."
    end

    field :hint, String, null: true do
      description "Help text for editors."
    end

    field :required, Boolean, null: false do
      description "Whether editors must provide a value."
    end

    field :available_on, [::Types::SolutionKindType, { null: false }], null: false do
      description "Which kinds of solution records have this property."
    end

    field :value_type, ::Types::SolutionPropertyValueType, null: false do
      description "What the value is, and what a client needs to edit it."
    end

    # @return [String, nil]
    def hint = object.input_hint.presence

    # @return [<String>]
    def available_on = ::SolutionProperty::SOURCE_KINDS.reject { object.skip_for?(_1) }.map(&:to_s)
  end
end
