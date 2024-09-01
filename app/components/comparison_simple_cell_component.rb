# frozen_string_literal: true

class ComparisonSimpleCellComponent < ApplicationComponent
  include AcceptsSolution

  # @return [String, nil]
  attr_reader :value

  # @param [Solution] solution
  # @param [Symbol] name
  def initialize(solution:, name:)
    @value = solution[name]
  end
end
