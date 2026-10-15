# frozen_string_literal: true

module Types
  # @see Resolvers::OrderedAsSolutionDraft
  class SolutionDraftOrderType < Types::BaseEnum
    description <<~TEXT
    Sort a collection of `SolutionDraft` records by specific properties and directions.
    TEXT

    value "DEFAULT" do
      description "Sort drafts with the most recently created first."
    end

    value "RECENT" do
      description "Sort drafts by newest created date."
    end

    value "OLDEST" do
      description "Sort drafts by oldest created date."
    end

    value "RECENT_UPDATES" do
      description "Sort drafts by most recently updated."
    end

    value "OLDEST_UPDATES" do
      description "Sort drafts by least recently updated."
    end
  end
end
