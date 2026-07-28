# frozen_string_literal: true

# @see SolutionIntake
class SolutionIntakesController < ApplicationController
  def show
    @solution_intake = SolutionIntake.find(params[:id])
  end

  def update
    @solution_intake = SolutionIntake.find(params[:id])

    @solution_intake.assign_attributes(solution_intake_params)

    saved = @solution_intake.save(validate: !skip_validations?)

    if skip_validations?
      flash.now[:alert] = t(".draft_not_saved") unless saved

      render :update, formats: :turbo_stream, status: saved ? :ok : :unprocessable_entity
    elsif saved
      redirect_to @solution_intake
    else
      render :show, status: :unprocessable_entity
    end
  end

  private

  def skip_validations?
    params[:skip_validations].present?
  end

  def solution_intake_params
    params.require(:solution_intake).permit!
  end
end
