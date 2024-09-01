# frozen_string_literal: true

# The component for rendering solution multiselection fields
# in a table row within the comparison page component.
#
# @see ComparisonComponent
class ComparisonMultiselectionRowComponent < ApplicationComponent
  # @return [Comparison]
  attr_reader :comparison

  # The name of the implementation
  # @return [Symbol]
  attr_reader :name

  alias connection_name name

  # @param [Comparison] comparison
  # @param [Symbol] connection name
  def initialize(comparison:, name:, truncate:)
    @comparison = comparison
    @name = name
    @truncate = truncate
  end

  # @param [Symbol] name
  def render_multiselection_cell(solution)
    render ComparisonMultiselectionCellComponent.new(solution:, name: @name, truncate: @truncate)
  end
end
