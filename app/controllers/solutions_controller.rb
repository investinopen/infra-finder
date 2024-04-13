# frozen_string_literal: true

# @see Solution
class SolutionsController < ApplicationController
  comparison_load_strategy :find_existing

  uncacheable! :index, :show

  def index
    set_current_open_graph!(image: "og/search.png")

    page_meta.site_title = t(".site_title", raise: true)

    open_graph.url = solutions_url

    search_and_load_solutions! refetch_comparison: false
  end

  def show
    @solution = Solution.publicly_accessible_for(current_user).find params[:id]

    solution_name = @solution.name

    page_meta.site_title = t(".site_title", solution_name:)

    set_current_open_graph!(image: "og/solution.png", solution_name:)

    open_graph.url = solution_url(@solution)
  end
end
