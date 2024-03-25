# frozen_string_literal: true

class SolutionLocationComponent < ApplicationComponent
  include AcceptsSolution

  # @return [Solution]
  attr_reader :solution

  # @param [Solution] solution
  # @param [Boolean] is_small
  def initialize(solution:)
    @solution = solution
  end
end
