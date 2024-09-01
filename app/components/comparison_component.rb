# frozen_string_literal: true

class ComparisonComponent < ApplicationComponent
  # @return [Comparison]
  attr_reader :comparison

  # @param [Comparison] comparison
  def initialize(comparison:)
    @comparison = comparison
  end

  # @param [Solutions::Types::Implementation] name
  def render_implementation_row(name)
    render ComparisonImplementationRowComponent.new(comparison:, name:)
  end

  # @param [String] name
  def render_multiselection_row(name, truncate: false)
    render ComparisonMultiselectionRowComponent.new(comparison:, name:, truncate:)
  end

  # @param [String] name
  def render_simple_row(name)
    render ComparisonSimpleRowComponent.new(comparison:, name:)
  end
end
