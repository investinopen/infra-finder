# frozen_string_literal: true

# Solution card grid component.
#
# @see SolutionComponent
class SolutionsComponent < ApplicationComponent
  # @return [Comparison, nil]
  attr_reader :comparison

  # @return [<Solution>]
  attr_reader :solutions

  # @param [ActiveRecord::Relation<Solution>] solutions
  # @param [Comparison] comparison
  def initialize(solutions: Solution.all, comparison: nil)
    @solutions = solutions
    @comparison = comparison
  end
end
