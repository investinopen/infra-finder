# frozen_string_literal: true

class ComparisonStickyHeaderComponent < ApplicationComponent
  # @return [Comparison]
  attr_reader :comparison

  # @return [String]
  attr_reader :heading

  # @param [Comparison] comparison
  # @param [String] name
  def initialize(comparison:, heading:)
    @comparison = comparison
    @heading = heading
  end
end
