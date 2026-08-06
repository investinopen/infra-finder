# frozen_string_literal: true

# @see SolutionIntake
class SolutionIntakesController < ApplicationController
  include Dry::Monads[:result]

  handles_forbidden!

  before_action :find_solution_intake!

  def show
    authorize @solution_intake

    if @solution_intake.pending?
      redirect_to edit_solution_intake_path(@solution_intake)

      return
    end
  end

  def edit
    unless policy(@solution_intake).edit?
      redirect_to @solution_intake, status: :see_other

      return
    end

    authorize @solution_intake
  end

  def update
    authorize @solution_intake

    request_context = SolutionIntakes::RequestContext.from(params)

    @draft = request_context.draft?

    case request_context.update!(@solution_intake)
    in Success(:draft)
      render(:update, formats: :turbo_stream, status: :ok)
    in Success
      redirect_to @solution_intake, status: :see_other
    in Failure(:draft)
      flash.now[:alert] = t(".draft_not_saved")

      render(:update, formats: :turbo_stream, status: :unprocessable_content)
    else
      render(:update, formats: :turbo_stream, status: :unprocessable_content)
    end
  end

  private

  # @return [void]
  def find_solution_intake!
    @solution_intake = policy_scope(SolutionIntake).find(params[:id])
  end
end
