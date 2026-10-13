# frozen_string_literal: true

module Types
  # @see Resolvers::OrderedAsUser
  class UserOrderType < Types::BaseEnum
    description <<~TEXT
    Sort a collection of `User` records by specific properties and directions.
    TEXT

    value "DEFAULT" do
      description "Sort users by their default order."
    end

    value "RECENT" do
      description "Sort users by newest created date."
    end

    value "OLDEST" do
      description "Sort users by oldest created date."
    end

    value "NAME_ASCENDING" do
      description "Sort users by name in ascending (A-Z) order."
    end

    value "NAME_DESCENDING" do
      description "Sort users by name in descending (Z-A) order."
    end

    value "EMAIL_ASCENDING" do
      description "Sort users by email in ascending (A-Z) order."
    end

    value "EMAIL_DESCENDING" do
      description "Sort users by email in descending (Z-A) order."
    end
  end
end
