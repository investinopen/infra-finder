# frozen_string_literal: true

class ComparisonBlurbRowComponent < ApplicationComponent
  # @return [Comparison]
  attr_reader :comparison

  # @return [String]
  attr_reader :name

  # @param [Comparison] comparison
  # @param [#to_s] blurb field name
  def initialize(comparison:, name:)
    @comparison = comparison
    @name = name
  end
end
