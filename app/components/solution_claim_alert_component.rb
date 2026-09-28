# frozen_string_literal: true

# Prompts providers to claim an unclaimed {Solution} via the external claim form.
#
# @see Solution#claimable?
class SolutionClaimAlertComponent < ApplicationComponent
  include AcceptsSolution

  # @return [Solution]
  attr_reader :solution

  # @param [Solution] solution
  def initialize(solution:)
    @solution = solution
  end

  def render? = solution.claimable?

  private

  def heading_id = dom_id(solution, :claim_alert_heading)
end
