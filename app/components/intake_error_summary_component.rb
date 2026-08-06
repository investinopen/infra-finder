# frozen_string_literal: true

# @see SolutionIntakesController#update
class IntakeErrorSummaryComponent < ApplicationComponent
  ID = "intake-error-summary"

  CONTROLLER = "intake-error-summary-component--intake-error-summary-component"

  include AcceptsSolutionIntake

  # @return [Boolean]
  attr_reader :draft

  alias draft? draft

  # @param [SolutionIntake] solution_intake
  # @param [Boolean] draft
  def initialize(solution_intake:, draft: false)
    super(solution_intake:)

    @draft = draft
  end

  # A draft save renders errors inline and doesn't move focus
  # @return [<SolutionIntakes::FormErrors::Entry>]
  def entries
    return [] if draft?

    form_errors.entries
  end
end
