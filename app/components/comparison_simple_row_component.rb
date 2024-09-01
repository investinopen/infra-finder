# frozen_string_literal: true

# The component for rendering basic fields
# in a table row within the comparison page component.
#
# @see ComparisonComponent
class ComparisonSimpleRowComponent < ApplicationComponent
  # @return [Comparison]
  attr_reader :comparison

  # The name of the implementation
  # @return [Symbol]
  attr_reader :name

  alias field_name name

  # @param [Comparison] comparison
  # @param [Symbol] field name
  def initialize(comparison:, name:)
    @comparison = comparison
    @name = name
  end

  # @param [Symbol] name
  def render_simple_cell(solution)
    render ComparisonSimpleCellComponent.new(solution:, name: @name)
  end
end
