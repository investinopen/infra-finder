# frozen_string_literal: true

module Types
  # An interface for types that support pagination.
  module PaginatedType
    include Types::BaseInterface

    description <<~TEXT
    Connections can be paginated by cursor or page number.
    TEXT

    field :page_info, Types::PageInfoType, null: false do
      description "Information to aid in pagination."
    end
  end
end
