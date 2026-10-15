# frozen_string_literal: true

module Types
  # @see Types::ImplementationLinkType
  class ImplementationLinkInputType < Types::BaseInputObject
    description <<~TEXT
    A link supporting one of a solution's implementations.
    TEXT

    argument :label, String, required: false do
      description "The link's label."
    end

    argument :url, String, required: true do
      description "The link's URL."
    end
  end
end
