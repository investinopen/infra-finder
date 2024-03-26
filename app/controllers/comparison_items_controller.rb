# frozen_string_literal: true

# Add or remove a parent {Solution} (from `:solution_id`) within a {Comparison}
class ComparisonItemsController < ApplicationController
  comparison_load_strategy :fetch

  def create
    @solution = Solution.find params[:solution_id]

    current_comparison.add(@solution) do |m|
      m.success do
        redirect_back fallback_location: solutions_path
      end

      m.failure :items_exceeded do |_, alert|
        redirect_back(fallback_location: solutions_path, alert:)
      end

      m.failure do
        # :nocov:
        redirect_back fallback_location: solutions_path, alert: t("api.errors.something_went_wrong")
        # :nocov:
      end
    end
  end

  def destroy
    @solution = Solution.find params[:solution_id]

    current_comparison.remove(@solution) do |m|
      m.success do
        redirect_back fallback_location: solutions_path
      end

      m.failure do
        # :nocov:
        redirect_back fallback_location: solutions_path, alert: t("api.errors.something_went_wrong")
        # :nocov:
      end
    end
  end
end
