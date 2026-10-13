# frozen_string_literal: true

module Types
  # @see Resolvers::OrderedAsProviderEditorAssignment
  class ProviderEditorAssignmentOrderType < Types::BaseEnum
    description <<~TEXT
    Sort a collection of `ProviderEditorAssignment` records by specific properties and directions.
    TEXT

    value "DEFAULT" do
      description "Sort provider editor assignments by their default order."
    end

    value "RECENT" do
      description "Sort provider editor assignments by newest created date."
    end

    value "OLDEST" do
      description "Sort provider editor assignments by oldest created date."
    end
  end
end
