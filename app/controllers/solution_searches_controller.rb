# frozen_string_literal: true

# @see Solution
class SolutionSearchesController < ApplicationController
  comparison_load_strategy :fetch

  # Only happens when there are errors, but we want to recover gracefully.
  def show
    redirect_to solutions_path
  end

  def create
    search_filters = params.permit(q: {}).to_h[:q] || {}

    current_comparison.apply_filters! search_filters

    respond_to do |format|
      format.html do
        redirect_back fallback_location: solutions_path
      end

      format.turbo_stream do
        search_and_load_solutions!
      end
    end
  end

  def destroy
    current_comparison.clear_filters!

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
