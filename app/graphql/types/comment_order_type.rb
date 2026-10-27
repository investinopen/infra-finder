# frozen_string_literal: true

module Types
  # @see Resolvers::OrderedAsComment
  class CommentOrderType < Types::BaseEnum
    description <<~TEXT
    Sort a collection of `Comment` records by specific properties and directions.
    TEXT

    value "DEFAULT" do
      description "Sort comments by oldest created date."
    end

    value "RECENT" do
      description "Sort comments by newest created date."
    end

    value "OLDEST" do
      description "Sort comments by oldest created date."
    end
  end
end
