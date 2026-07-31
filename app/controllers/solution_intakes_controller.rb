# frozen_string_literal: true

# @see SolutionIntake
class SolutionIntakesController < ApplicationController
  before_action :find_solution_intake!

  def show
    render :confirmation unless @solution_intake.pending?
  end

  def update
    return redirect_to @solution_intake, status: :see_other unless @solution_intake.pending?

    @solution_intake.assign_attributes(solution_intake_params)

    saved = @solution_intake.save(validate: !skip_validations?)

    if skip_validations?
      flash.now[:alert] = t(".draft_not_saved") unless saved

      render :update, formats: :turbo_stream, status: saved ? :ok : :unprocessable_entity
    elsif saved
      @solution_intake.transition_to! :in_review

      redirect_to @solution_intake, status: :see_other
    else
      respond_to do |format|
        format.turbo_stream { render :invalid, status: :unprocessable_entity }
        format.html { render :show, status: :unprocessable_entity }
      end
    end
  end

  private

  def find_solution_intake!
    @solution_intake = SolutionIntake.find(params[:id])
  end

  def skip_validations?
    params[:skip_validations].present?
  end

  def solution_intake_params
    params.require(:solution_intake).permit!
  end
end
