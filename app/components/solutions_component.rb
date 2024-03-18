# frozen_string_literal: true

# Solution card grid component.
#
# @see SolutionComponent
class SolutionsComponent < ApplicationComponent
  # @return [Comparison, nil]
  attr_reader :comparison

  # @return [<Solution>]
  attr_reader :solutions

  # @return [Ransack::Search]
  attr_reader :solution_search

  # @param [ActiveRecord::Relation<Solution>] solutions
  # @param [Ransack::Search] solution_search
  # @param [Comparison] comparison
  def initialize(solutions: Solution.all, comparison: nil, solution_search: Solution.all.ransack({}))
    @solutions = solutions
    @comparison = comparison
    @solution_search = solution_search
  end
end
