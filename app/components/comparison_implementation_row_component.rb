# frozen_string_literal: true

# The component for rendering solution implementations in
# a table row within the comparison page component.
#
# @see ComparisonComponent
class ComparisonImplementationRowComponent < ApplicationComponent
  # @return [Comparison]
  attr_reader :comparison

  # @return [Implementations::AbstractImplementation]
  attr_reader :implementation

  # The name of the implementation
  # @return [Symbol]
  attr_reader :name

  alias implementation_name name

  # @param [Comparison] comparison
  # @param [#to_s] implementation name
  def initialize(comparison:, name:)
    @comparison = comparison
    @name = ::Solutions::Types::Implementation[name]
  end

  # @param [Solutions::Types::Implementation] name
  # @return [String]
  def render_implementation_cell(solution)
    render ComparisonImplementationCellComponent.new(solution:, name: @name)
  end
end
