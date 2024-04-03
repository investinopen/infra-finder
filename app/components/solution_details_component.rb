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

  # @return [Boolean]
  attr_reader :has_policies

  # @param [Solution] solution
  # @param [Comparison, nil] comparison
  def initialize(solution:, comparison: nil)
    @solution = solution
    @comparison = comparison
    @formatted_num_staff = number_with_delimiter(solution.current_staffing)
    @has_policies = solution.bylaws? or solution.equity_and_inclusion? or solution.privacy_policy? or solution.web_accessibility? or solution.open_data?
  end

  # @param [Solutions::Types::Implementation] name
  # @return [String]
  def render_implementation(name)
    render ImplementationDetailComponent.new(solution:, name:)
  end

  def render_location
    render SolutionLocationComponent.new(solution:)
  end

  def render_category_badges
    render SolutionCategoryBadgesComponent.new(solution:)
  end
end
