# frozen_string_literal: true

# @see Solution
class SolutionSortsController < ApplicationController
  comparison_load_strategy :fetch

  def create
    params.permit(q: { s: [] })

    sort_param = params.dig(:q, :s)

    current_comparison.apply_sorts!(sort_param)

    respond_to do |format|
      format.html do
        redirect_back fallback_location: solutions_path
      end

      format.turbo_stream do
        search_and_load_solutions!
      end
    end
  end
end
