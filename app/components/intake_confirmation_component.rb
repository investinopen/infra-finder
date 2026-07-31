# frozen_string_literal: true

# @see SolutionIntakesController#show
class IntakeConfirmationComponent < ApplicationComponent
  # @return [SolutionIntake]
  attr_reader :solution_intake

  delegate :in_review?, to: :solution_intake

  # @param [SolutionIntake] solution_intake
  def initialize(solution_intake:)
    @solution_intake = solution_intake
  end
end
