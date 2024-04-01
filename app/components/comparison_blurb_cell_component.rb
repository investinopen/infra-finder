# frozen_string_literal: true

class ComparisonBlurbCellComponent < ApplicationComponent
  with_collection_parameter :item

  # @return [ComparisonItem]
  attr_reader :item

  # @return [String]
  attr_reader :name

  delegate :comparison, :solution, to: :item

  # @param [ComparisonItem] item
  # @param [String] name of property
  def initialize(item:, name:)
    @item = item
    @name = name
  end
end
