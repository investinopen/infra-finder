# frozen_string_literal: true

# The default solution "card" component, used for rendering {Solution}s
# on the /solutions list.
class SolutionComponent < ApplicationComponent
  include AcceptsSolution

  # @return [Comparison, nil]
  attr_reader :comparison

  # @return [ActionView::PartialIteration]
  attr_reader :iteration

  # @return [Solution]
  attr_reader :solution

  # @param [Solution] solution
  # @param [Comparison, nil] comparison
  # @param [ActionView::PartialIteration] solution_iteration a magic value populated
  #   by the parent component's `with_collection` call.
  def initialize(solution:, comparison: nil, solution_iteration: ActionView::PartialIteration.new(1))
    @solution = solution
    @comparison = comparison
    @iteration = solution_iteration
  end

  # @param [Solutions::Types::Implementation] name
  # @return [String]
  def render_implementation(name)
    render ImplementationComponent.new(solution:, name:)
  end
end
