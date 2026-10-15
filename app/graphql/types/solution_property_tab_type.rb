# frozen_string_literal: true

module Types
  # A tab of the solution form, as laid out in ActiveAdmin.
  #
  # @see AdminTab
  class SolutionPropertyTabType < Types::BaseObject
    description <<~TEXT
    A tab of the solution form, grouping properties in display order.
    TEXT

    field :name, String, null: false do
      description "The tab's name."
    end

    field :properties, [::Types::SolutionPropertyType, { null: false }], null: false do
      description "The tab's properties, in order. Implementation statuses and links appear once, as their implementation."
    end

    # @return [<SolutionProperty>]
    def properties
      object.property_wrappers.map(&:property).uniq
    end
  end
end
