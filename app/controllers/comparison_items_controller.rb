# frozen_string_literal: true

# Add or remove a parent {Solution} (from `:solution_id`) within a {Comparison}
class ComparisonItemsController < ApplicationController
  comparison_load_strategy :fetch

  def create
    @solution = Solution.find params[:solution_id]

    current_comparison.add(@solution) do |m|
      m.success do
        respond_to do |format|
          format.html do
            redirect_back fallback_location: solutions_path
          end

          format.turbo_stream do
            refetch_current_comparison!
          end
        end
      end

      m.failure :items_exceeded do |_, alert|
        respond_to do |format|
          format.html do
            redirect_back(fallback_location: solutions_path, alert:)
          end

          format.turbo_stream do
            refetch_current_comparison!

            flash.now[:alert] = alert

            @show_flash = true
          end
        end
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
        respond_to do |format|
          format.html do
            redirect_back fallback_location: solutions_path
          end

          format.turbo_stream do
            refetch_current_comparison!

            if request_from_comparison? && current_comparison.items_incomparable?
              flash[:alert] = t("comparisons.show.not_enough_selected")

              render turbo_stream: turbo_stream.action(:redirect, comparison_url)
            end
          end
        end
      end

      m.failure do
        # :nocov:
        redirect_back fallback_location: solutions_path, alert: t("api.errors.something_went_wrong")
        # :nocov:
      end
    end
  end
end
