# frozen_string_literal: true

module Types
  # Queries for the metadata describing solution properties.
  module QueriesSolutionProperty
    include Types::BaseInterface

    description <<~TEXT
    Queries for the metadata describing solution properties.
    TEXT

    field :solution_properties, [::Types::SolutionPropertyType, { null: false }], null: false do
      description "Every solution property that holds a value, in property order."
    end

    field :solution_property_tabs, [::Types::SolutionPropertyTabType, { null: false }], null: false do
      description "The solution form's tabs, in order."
    end

    # @return [<SolutionProperty>]
    def solution_properties
      SolutionProperty.in_use.to_a.sort.reject { _1.kind.in?(SolutionProperty::GRAPHQL_METADATA_EXCLUDED_KINDS) }
    end

    # @return [<AdminTab>]
    def solution_property_tabs
      AdminTab.all.to_a
    end
  end
end
