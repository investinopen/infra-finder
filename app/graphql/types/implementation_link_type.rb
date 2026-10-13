# frozen_string_literal: true

module Types
  # @see Implementations::Link
  class ImplementationLinkType < Types::BaseObject
    description <<~TEXT
    A link supporting one of a solution's implementations.
    TEXT

    field :label, String, null: true do
      description "The link's label."
    end

    field :url, String, null: true do
      description "The link's URL."
    end
  end
end
