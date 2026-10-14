# frozen_string_literal: true

module Types
  # @see Solutions::Revisions::Diffs::BaseDiff
  class SolutionRevisionDiffType < Types::BaseObject
    description <<~TEXT
    A change to one property recorded by a `SolutionRevision`. The values are stored with the
    revision, so their shape follows the property's `valueType` at the time of the change.
    TEXT

    field :name, String, null: false do
      description "The name of the property that changed."
    end

    field :property, ::Types::SolutionPropertyType, null: true do
      description "The property that changed. Null for properties that no longer exist."
    end

    field :verb, ::Types::SolutionRevisionDiffVerbType, null: false do
      description "What happened to the value."
    end

    field :old_value, GraphQL::Types::JSON, null: true do
      description "The value before the change."
    end

    field :new_value, GraphQL::Types::JSON, null: true do
      description "The value after the change."
    end

    # @return [SolutionProperty, nil]
    def property = SolutionProperty.find_by(name: object.name)
  end
end
