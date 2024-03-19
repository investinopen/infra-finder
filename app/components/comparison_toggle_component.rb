# frozen_string_literal: true

# An anchor tag masquerading as a button that toggles whether or not the provided
# solution should be added or removed from the session's {Comparison}.
class ComparisonToggleComponent < ApplicationComponent
  # @return [Comparison, nil]
  attr_reader :comparison

  # @return [Boolean]
  attr_reader :comparing

  alias comparing? comparing

  # @api private
  # @return [Hash]
  attr_reader :link_options

  # @return [Solution]
  attr_reader :solution

  # @param [Solution] solution
  # @param [Comparison, nil] comparison
  def initialize(solution:, comparison: nil)
    @solution = solution
    @comparison = comparison

    @comparing = comparison.present? && solution.in?(comparison.solutions)

    @link_options = build_link_options
  end

  def message
    t(".compare")
  end

  private

  def build_link_options
    {
      class: "comparison-toggle m-button #{comparing? ? "bg-brand-mint" : ""}",
      data: {
        controller: "comparison-toggle-component--comparison-toggle-component",
        turbo_frame: "solutions-index",
        "turbo-method": comparing? ? :delete : :post,
      },
      role: "button",
      "aria-pressed": comparing.to_s,
    }
  end
end
