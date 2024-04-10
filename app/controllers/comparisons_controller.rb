# frozen_string_literal: true

class ComparisonsController < ApplicationController
  comparison_load_strategy :find_existing

  def show
    if current_comparison.blank?
      redirect_to solutions_path, notice: t(".select_some_comparisons")

      return
    end

    unless current_comparison.comparison_items.many?
      redirect_to solutions_path, notice: t(".not_enough_selected")

      return
    end
  end

  # @note The destroy action actually just clears the current comparison's items, since
  #   we want to maintain the filters, etc.
  def destroy
    current_comparison.comparison_items.destroy_all if current_comparison.present?

    respond_to do |format|
      format.html do
        redirect_back fallback_location: solutions_path
      end

      format.turbo_stream do
        search_and_load_solutions! refetch_comparison: true
      end
    end
  end
end
