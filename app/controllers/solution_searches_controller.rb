# frozen_string_literal: true

# @see Solution
class SolutionSearchesController < ApplicationController
  comparison_load_strategy :fetch

  def create
    search_filters = params.permit(q: {}).to_h[:q] || {}

    current_comparison.apply_filters! search_filters

    redirect_back fallback_location: solutions_path
  end

  def destroy
    current_comparison.clear_filters!

    redirect_back fallback_location: solutions_path
  end
end
