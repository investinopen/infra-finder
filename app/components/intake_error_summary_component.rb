# frozen_string_literal: true

# @see SolutionIntakesController#update
class IntakeErrorSummaryComponent < ApplicationComponent
  CONTROLLER = "intake-error-summary-component--intake-error-summary-component"

  # @return [SolutionIntake]
  attr_reader :solution_intake

  # @param [SolutionIntake] solution_intake
  def initialize(solution_intake:)
    @solution_intake = solution_intake
  end

  def render?
    form_errors.any?
  end

  # @return [<SolutionIntakes::FormErrors::Entry>]
  def entries
    form_errors.entries
  end

  private

  # @return [SolutionIntakes::FormErrors]
  def form_errors
    @form_errors ||= SolutionIntakes::FormErrors.new(solution_intake)
  end
end
