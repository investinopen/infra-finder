# frozen_string_literal: true

class SolutionCategoryBadgesComponent < ApplicationComponent
  include AcceptsSolution

  # @return [Solution]
  attr_reader :solution

  # @return [Boolean]
  attr_reader :is_small

  # @param [Solution] solution
  # @param [Boolean] is_small
  def initialize(solution:, is_small: false)
    @solution = solution
    @is_small = is_small
  end
end
