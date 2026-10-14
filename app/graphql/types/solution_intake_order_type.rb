# frozen_string_literal: true

module Types
  # @see Resolvers::OrderedAsSolutionIntake
  class SolutionIntakeOrderType < Types::BaseEnum
    description <<~TEXT
    Sort a collection of `SolutionIntake` records by specific properties and directions.
    TEXT

    value "DEFAULT" do
      description "Sort intakes with the most recently created first."
    end

    value "RECENT" do
      description "Sort intakes by newest created date."
    end

    value "OLDEST" do
      description "Sort intakes by oldest created date."
    end
  end
end
