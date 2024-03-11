# frozen_string_literal: true

class ComparisonComponent < ApplicationComponent
  # @return [Comparison]
  attr_reader :comparison

  # @param [Comparison] comparison
  def initialize(comparison:)
    @comparison = comparison
  end
end
