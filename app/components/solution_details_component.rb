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
    # render ImplementationStatementComponent.new(solution:, name:)
  end

  def render_location
    render SolutionLocationComponent.new(solution:)
  end

  def render_category_badges
    render SolutionCategoryBadgesComponent.new(solution:)
  end

  def render_multiselection(name, layout = "default", column_count = 3, hide_other: false)
    render SolutionMultiselectionComponent.new(solution:, name:, layout:, column_count:, hide_other:)
  end

  def render_multiselection_card(name)
    render SolutionMultiselectionCardComponent.new(solution:, name:)
  end

  def render_multiselection_other(name)
    render SolutionMultiselectionOtherComponent.new(solution:, name:)
  end

  def render_structured_list(name, free_text = nil)
    render SolutionStructuredListComponent.new(solution:, name:, free_text:)
  end

  COMMUNITY_ATTRS = %i[
    community_engagement_activities
    values_frameworks
    membership_program_url
    scoss
    user_contributions
  ].freeze

  COMMUNITY_IMPLEMENTATIONS = %i[
    code_of_conduct
    community_engagement
    contribution_pathways
  ].freeze

  def show_community_section?
    COMMUNITY_ATTRS.any? { solution.__send__(_1).present? } || COMMUNITY_IMPLEMENTATIONS.any? do |implementation|
      solution.__send__(implementation).in_progress? || solution.__send__(implementation).available?
    end
  end
end
