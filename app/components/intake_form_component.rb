# frozen_string_literal: true

class IntakeFormComponent < ApplicationComponent
  FORM_ID = "solution-intake-form"

  # @return [SolutionIntake]
  attr_reader :solution_intake

  # @api private
  # @return [String]
  attr_reader :form_id

  # @param [SolutionIntake] solution_intake
  # @param [String] form_id
  def initialize(solution_intake:, form_id: FORM_ID)
    @solution_intake = solution_intake
    @form_id = form_id
  end
end
