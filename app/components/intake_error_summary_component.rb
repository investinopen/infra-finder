# frozen_string_literal: true

# @see SolutionIntakesController#update
class IntakeErrorSummaryComponent < ApplicationComponent
  CONTROLLER = "intake-error-summary-component--intake-error-summary-component"

  include AcceptsSolutionIntake

  def render?
    form_errors.any?
  end

  # @return [<SolutionIntakes::FormErrors::Entry>]
  def entries
    form_errors.entries
  end
end
