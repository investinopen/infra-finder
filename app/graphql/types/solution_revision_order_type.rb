# frozen_string_literal: true

module Types
  # @see Resolvers::OrderedAsSolutionRevision
  class SolutionRevisionOrderType < Types::BaseEnum
    description <<~TEXT
    Sort a collection of `SolutionRevision` records by specific properties and directions.
    TEXT

    value "DEFAULT" do
      description "Sort revisions with the most recently created first."
    end

    value "RECENT" do
      description "Sort revisions by newest created date."
    end

    value "OLDEST" do
      description "Sort revisions by oldest created date."
    end
  end
end
