# frozen_string_literal: true

module Types
  # @see Implementations::AbstractImplementation.link_mode
  class ImplementationLinkModeType < Types::BaseEnum
    description <<~TEXT
    How many supporting links an implementation takes.
    TEXT

    value "NONE", description: "No links."
    value "SINGLE", description: "One link."
    value "MANY", description: "Any number of links."
  end
end
