# frozen_string_literal: true

# @see Solution
class SolutionsController < ApplicationController
  comparison_load_strategy :find_existing

  uncacheable! :index, :show

  def index
    search_and_load_solutions! refetch_comparison: false
  end

  def show
    @solution = Solution.publicly_accessible_for(current_user).find params[:id]
  end
end
