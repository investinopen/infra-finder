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
end
