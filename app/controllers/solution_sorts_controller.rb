# frozen_string_literal: true

# @see Solution
class SolutionSortsController < ApplicationController
  comparison_load_strategy :fetch

  def create
    params.permit(q: { s: [] })

    sort_param = params.dig(:q, :s)

    current_comparison.apply_sorts!(sort_param)

    redirect_back fallback_location: solutions_path
  end
end
