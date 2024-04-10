# frozen_string_literal: true

# @see Solution
class SolutionsController < ApplicationController
  comparison_load_strategy :find_existing

  def index
    search_and_load_solutions! refetch_comparison: false
  end

  def show
    @solution = Solution.find params[:id]
  end
end
