# frozen_string_literal: true

# The "show" component for a {Solution}, corresponding to `/solutions/:id`.
class SolutionDetailsComponent < ApplicationComponent
  include AcceptsSolution

  # @return [Comparison, nil]
  attr_reader :comparison

  # @return [Solution]
  attr_reader :solution

  # @return [String, nil]
  attr_reader :formatted_num_staff

  # @param [Solution] solution
  # @param [Comparison, nil] comparison
  def initialize(solution:, comparison: nil)
    @solution = solution
    @comparison = comparison
    @formatted_num_staff = number_with_delimiter(solution.current_staffing)
  end

  # @param [Solutions::Types::Implementation] name
  # @return [String]
  def render_implementation(name)
    render ImplementationDetailComponent.new(solution:, name:)
  end

  # @param [Solutions::Types::Implementation] name
  # @return [String]
  def render_implementation_statement(name)
    render ImplementationStatementComponent.new(solution:, name:)
  end

  def render_location
    render SolutionLocationComponent.new(solution:)
  end

  def render_category_badges
    render SolutionCategoryBadgesComponent.new(solution:)
  end

  def render_multiselection(name, layout = "default", column_count = 3)
    render SolutionMultiselectionComponent.new(solution:, name:, layout:, column_count:)
  end

  def render_multiselection_card(name)
    render SolutionMultiselectionCardComponent.new(solution:, name:)
  end

  def render_structured_list(name, free_text = nil)
    render SolutionStructuredListComponent.new(solution:, name:, free_text:)
  end
end
